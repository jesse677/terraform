terraform {
  source = "../../modules/kubernetes/cluster"
}

locals {
  # SSH configuration
  ssh_user        = "ubuntu"
  ssh_private_key = "~/.ssh/id_rsa"
  
  # K3s cluster configuration
  k3s_version = "v1.30.4+k3s1"
  
  # Node configurations from VM deployments
  nodes = {
    "k3s-node-01" = {
      external_ip = "192.168.20.21"
      internal_ip = "192.168.30.21"
    }
    "k3s-node-02" = {
      external_ip = "192.168.20.22"
      internal_ip = "192.168.30.22"
    }
    "k3s-node-03" = {
      external_ip = "192.168.20.23"
      internal_ip = "192.168.30.23"
    }
  }
}

inputs = {
  cluster_name = "k3s-cluster"
  k3s_version  = local.k3s_version
  
  # All nodes configured as server nodes for HA
  server_nodes = {
    for name, config in local.nodes : name => {
      host        = name
      internal_ip = config.internal_ip
      external_ip = config.external_ip
      user        = local.ssh_user
      private_key = local.ssh_private_key
      labels = {
        "node-role.kubernetes.io/master" = "true"
        "node.kubernetes.io/exclude-from-external-load-balancers" = "true"
      }
    }
  }
  
  # No dedicated agent nodes - all nodes are control plane
  agent_nodes = {}
  
  # Network configuration
  cluster_cidr = "10.42.0.0/16"
  service_cidr = "10.43.0.0/16"
  cluster_dns  = "10.43.0.10"
  
  # Flannel VXLAN for overlay network
  flannel_backend = "vxlan"
  
  # Disable traefik and servicelb to use custom ingress/load balancer
  disable_components = ["traefik", "servicelb"]
  
  # Additional server arguments
  server_args = [
    "--disable-cloud-controller",
    "--kube-apiserver-arg=feature-gates=GracefulNodeShutdown=true",
    "--kube-controller-manager-arg=node-monitor-grace-period=120s",
    "--kube-controller-manager-arg=node-monitor-period=20s",
    "--kubelet-arg=node-status-update-frequency=20s"
  ]
}

# Dependency on VMs being created
dependencies {
  paths = [
    "../proxmox/vms/k3s-node-01",
    "../proxmox/vms/k3s-node-02",
    "../proxmox/vms/k3s-node-03"
  ]
}