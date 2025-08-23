include "root" {
  path = find_in_parent_folders("k3s-root.hcl")
}

include "k3s_node" {
  path = find_in_parent_folders("_envcommon/k3s-node.hcl")
}

terraform {
  source = "../../../modules/proxmox/vm"
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("k3s-root.hcl"))
  node_config = {
    name            = "k3s-agent-02"
    node            = "pve-node-03"
    public_ip       = "192.168.20.23"
    sleep_time      = 90
  }
}

inputs = {
  # Node-specific overrides
  name            = local.node_config.name
  node_name       = local.node_config.node

  ip_configs = [
    {
      address = "${local.node_config.public_ip}/24"
      gateway = local.root.locals.public_gateway
    }
  ]

  # K3s-specific disk configuration with additional storage for Ceph
  disks = [
    {
      datastore_id = local.root.locals.disk_datastore
      file_id      = local.root.locals.disk_template
      interface    = "scsi0"
      size         = 50
      file_format  = "raw"
    },
    # Additional disk for Ceph storage
    {
      datastore_id = local.root.locals.disk_datastore
      interface    = "scsi1"
      size         = 50
      file_format  = "raw"
    }
  ]

  user_data = <<-EOT
    #cloud-config
    hostname: ${local.node_config.name}
    package_update: true
    package_upgrade: true

    packages: ${jsonencode(local.root.locals.base_packages)}

    users:
      - name: ubuntu
        groups: sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        ssh_authorized_keys:
          - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjfBxebcWoJiUYWOlJtSxh35mc/g5DshPiE/OY4KAUueMzPFy5zYPtK6nvTVOaP1JQ5ZzZBlZ7CuQ/K1Qc4AUVcVkBy+MZvbpCiZrokVXcbA17ZcCPnynWVL/XmRlhVfGN1PSK2tpsDJoG1NPPSVlmyBe6bhp/2ZmwvQ89HIc6Tj1pyUNadnGqzjGruPBlUCbxyEoVOool7r1XO2a7gFa3jx+jsFygMNrtMyrKG8vsGT9aYuM/cXbf6M/cNftQ1JXiTkIN2cr6rggxeQ3xL4/8n8f0N78k26uX65ZtIgQgHafn2mUvkcHWx4oUFzwMSkHfWqVgwh6Sfj0MvjX4LepV6whZW+gwpsEJySZNhkKFJqwvZ+QDJbfcsiaomM5D8b/+G3dOc61nwbV3MGnTnH7l0d9yTILYhDZrLBx5Ig+bfB567AMWBnoXHFWfa1DPmsCRuAljB453BRxLi5jV87y7xlUb8xiJ/rv4/6+qAgueSfAI5d0/o9aiUrs88Ua+SujI0J4FFiF60K/9+BGCyGVUyFLqlacvqYSGV2asRiKnJXHUTiHfdsgugphAjJ3RWg0sUkMnDPMgcOMvhCBoMTn7aHipaTV7WvcG6ddaxRiT7fxlFvwW7a1Fff5903hjjNZDqCGrcDDLnwBZu8Bm8G0PzAYBVhtPFU7l0k4VKkwX3Q== jesse@jtdt01

    ssh_pwauth: false
    disable_root: false

    write_files:
      - path: /etc/ssh/sshd_config.d/99-cloud-init.conf
        content: |
          PasswordAuthentication no
          PubkeyAuthentication yes
          PermitRootLogin no
        permissions: '0644'
      - path: /etc/rancher/k3s/registries.yaml
        content: |
          mirrors:
            docker.io:
              endpoint:
                - "https://registry-1.docker.io"
        owner: root:root
        permissions: '0644'
      - path: /tmp/install-k3s-agent.sh
        content: |
          #!/bin/bash
          set -e
          echo "Starting K3s agent installation at $(date)" >> /home/ubuntu/k3s-install.log
          
          # Wait for server to be ready with proper health check
          echo "Waiting for K3s server to be ready..." >> /home/ubuntu/k3s-install.log
          for i in {1..30}; do
            if curl -k --connect-timeout 5 https://${local.root.locals.k3s_server_ip}:6443/readyz > /dev/null 2>&1; then
              echo "K3s server is ready after $i attempts" >> /home/ubuntu/k3s-install.log
              break
            fi
            echo "Attempt $i: Server not ready yet, waiting..." >> /home/ubuntu/k3s-install.log
            sleep 10
          done
          
          # Install K3s agent
          echo "Installing K3s agent..." >> /home/ubuntu/k3s-install.log
          export K3S_URL=https://${local.root.locals.k3s_server_ip}:6443
          export K3S_TOKEN='${local.root.locals.k3s_token}'
          
          curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip ${local.node_config.public_ip} --flannel-iface=eth0" sh - >> /home/ubuntu/k3s-install.log 2>&1
          
          # Verify installation
          echo "Verifying K3s agent installation..." >> /home/ubuntu/k3s-install.log
          systemctl enable k3s-agent >> /home/ubuntu/k3s-install.log 2>&1
          systemctl start k3s-agent >> /home/ubuntu/k3s-install.log 2>&1
          
          # Wait for agent to be ready
          for i in {1..12}; do
            if systemctl is-active k3s-agent > /dev/null 2>&1; then
              echo "K3s agent is running after $i attempts" >> /home/ubuntu/k3s-install.log
              break
            fi
            echo "Attempt $i: Agent not running yet, waiting..." >> /home/ubuntu/k3s-install.log
            sleep 5
          done
          
          echo "K3s agent installation completed at $(date)" >> /home/ubuntu/k3s-install.log
        permissions: '0755'

    runcmd: ${jsonencode(concat(
      local.root.locals.base_runcmds,
      [
        "# Restart SSH service to apply configuration changes",
        "systemctl restart ssh"
      ],
      local.root.locals.host_entries,
      local.root.locals.k3s_agent_runcmds,
      [
        "# Install K3s agent with proper error handling",
        "sudo -u ubuntu bash /tmp/install-k3s-agent.sh"
      ],
      local.root.locals.ceph_runcmds
    ))}

    final_message: "Node setup complete, check /home/ubuntu/k3s-install.log for K3s agent status"
  EOT
}