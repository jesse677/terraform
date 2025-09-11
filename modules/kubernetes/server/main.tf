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
    local.taints_args
  )
  
  install_script = <<-EOT
    #!/bin/bash
    set -e
    
    # Check if K3s is already installed
    if command -v k3s &> /dev/null; then
      echo "K3s is already installed, checking version..."
      CURRENT_VERSION=$(k3s --version | grep -oP 'k3s version \K[^ ]+')
      if [ "$CURRENT_VERSION" == "${var.k3s_version}" ]; then
        echo "K3s ${var.k3s_version} is already installed"
        exit 0
      else
        echo "Upgrading K3s from $CURRENT_VERSION to ${var.k3s_version}"
      fi
    fi
    
    # Install K3s
    export INSTALL_K3S_VERSION="${var.k3s_version}"
    export K3S_NODE_NAME="${var.node_name}"
    export INSTALL_K3S_EXEC="server ${join(" ", local.all_args)}"
    
    curl -sfL https://get.k3s.io | sh -
    
    # Wait for K3s to be ready
    for i in {1..60}; do
      if sudo k3s kubectl get nodes &> /dev/null; then
        echo "K3s is ready"
        break
      fi
      echo "Waiting for K3s to be ready... ($i/60)"
      sleep 5
    done
    
    # Verify installation
    sudo k3s kubectl get nodes
  EOT
}

resource "null_resource" "k3s_server" {
  connection {
    type        = "ssh"
    host        = var.external_ip
    user        = var.user
    private_key = file(var.private_key)
    timeout     = "5m"
  }
  
  provisioner "remote-exec" {
    inline = [
      "echo 'Preparing system for K3s installation...'",
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
    destination = "/tmp/install_k3s.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_k3s.sh",
      "sudo /tmp/install_k3s.sh",
      "rm /tmp/install_k3s.sh"
    ]
  }
  
  triggers = {
    node_name   = var.node_name
    k3s_version = var.k3s_version
    k3s_args    = join(",", local.all_args)
  }
}

resource "null_resource" "wait_for_node" {
  depends_on = [null_resource.k3s_server]
  
  provisioner "local-exec" {
    command = <<-EOT
      for i in {1..60}; do
        if ssh -o StrictHostKeyChecking=no -i ${var.private_key} \
          ${var.user}@${var.external_ip} \
          'sudo k3s kubectl get node ${var.node_name} | grep -q Ready'; then
          echo "Node ${var.node_name} is ready"
          exit 0
        fi
        echo "Waiting for node ${var.node_name} to be ready... ($i/60)"
        sleep 5
      done
      echo "Timeout waiting for node ${var.node_name}"
      exit 1
    EOT
  }
  
  triggers = {
    node = var.node_name
  }
}