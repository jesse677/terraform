terraform {
  required_version = ">= 1.0"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}

locals {
  labels_args = [for k, v in var.labels : "--node-label=${k}=${v}"]
  taints_args = [for taint in var.taints : "--node-taint=${taint}"]
  
  all_args = concat(
    var.k3s_args,
    local.labels_args,
    local.taints_args,
    [
      "--node-ip=${var.internal_ip}",
      "--node-external-ip=${var.external_ip}"
    ]
  )
  
  install_script = <<-EOT
    #!/bin/bash
    set -e
    
    # Check if K3s is already installed
    if command -v k3s-agent &> /dev/null; then
      echo "K3s agent is already installed, checking version..."
      CURRENT_VERSION=$(k3s-agent --version 2>&1 | grep -oP 'k3s version \K[^ ]+' || true)
      if [ "$CURRENT_VERSION" == "${var.k3s_version}" ]; then
        echo "K3s agent ${var.k3s_version} is already installed"
        exit 0
      else
        echo "Upgrading K3s agent from $CURRENT_VERSION to ${var.k3s_version}"
      fi
    fi
    
    # Install K3s agent
    export INSTALL_K3S_VERSION="${var.k3s_version}"
    export K3S_NODE_NAME="${var.node_name}"
    export INSTALL_K3S_EXEC="agent ${join(" ", local.all_args)}"
    
    curl -sfL https://get.k3s.io | sh -
    
    # Wait for K3s agent to be ready
    for i in {1..60}; do
      if sudo systemctl is-active --quiet k3s-agent; then
        echo "K3s agent is running"
        break
      fi
      echo "Waiting for K3s agent to start... ($i/60)"
      sleep 5
    done
    
    # Verify agent is running
    sudo systemctl status k3s-agent --no-pager
  EOT
}

resource "null_resource" "k3s_agent" {
  connection {
    type        = "ssh"
    host        = var.external_ip
    user        = var.user
    private_key = file(var.private_key)
    timeout     = "5m"
  }
  
  provisioner "remote-exec" {
    inline = [
      "echo 'Preparing system for K3s agent installation...'",
      "sudo apt-get update",
      "sudo apt-get install -y curl wget",
      "sudo systemctl stop ufw || true",
      "sudo systemctl disable ufw || true",
      "sudo modprobe br_netfilter",
      "sudo modprobe overlay",
      "echo 'br_netfilter' | sudo tee /etc/modules-load.d/k3s.conf",
      "echo 'overlay' | sudo tee -a /etc/modules-load.d/k3s.conf",
      "echo 'net.bridge.bridge-nf-call-iptables = 1' | sudo tee /etc/sysctl.d/k3s.conf",
      "echo 'net.bridge.bridge-nf-call-ip6tables = 1' | sudo tee -a /etc/sysctl.d/k3s.conf",
      "echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/k3s.conf",
      "sudo sysctl --system"
    ]
  }
  
  provisioner "file" {
    content     = local.install_script
    destination = "/tmp/install_k3s_agent.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_k3s_agent.sh",
      "sudo /tmp/install_k3s_agent.sh",
      "rm /tmp/install_k3s_agent.sh"
    ]
  }
  
  triggers = {
    node_name   = var.node_name
    k3s_version = var.k3s_version
    k3s_args    = join(",", local.all_args)
  }
}