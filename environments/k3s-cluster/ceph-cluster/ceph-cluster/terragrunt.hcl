include "k3s_root" {
  path = "../../k3s-root.hcl"
}

include "kubernetes" {
  path = find_in_parent_folders("_envcommon/kubernetes.hcl")
}

terraform {
  source = "../../../../modules/kubernetes/ceph-cluster"
}

dependencies {
  paths = ["../rook-operator"]
}

locals {
  k3s_root = read_terragrunt_config("../../k3s-root.hcl")
}

inputs = {
  # Kubernetes connection configuration
  kubernetes_server_endpoint = "https://${local.k3s_root.locals.k3s_server_ip}:6443"
  kubernetes_config_path    = "${pathexpand("~")}/.kube/config"
  
  # Ceph cluster configuration
  namespace = "rook-ceph"
  cluster_name = "rook-ceph"
  ceph_version_image = "quay.io/ceph/ceph:v18.2.4"
  
  # Storage nodes configuration  
  storage_nodes = [
    {
      name = "k3s-server-01"
      devices = [
        {
          name = "/dev/sdb"
        }
      ]
    },
    {
      name = "k3s-agent-01" 
      devices = [
        {
          name = "/dev/sdb"
        }
      ]
    },
    {
      name = "k3s-agent-02"
      devices = [
        {
          name = "/dev/sdb"
        }
      ]
    }
  ]
  
  # Storage configuration - use specific devices instead of auto-discovery
  use_all_nodes = false
  use_all_devices = false
  
  # Monitor volume configuration
  mon_volume_claim_template = {
    storage_class_name = "local-path"
    storage_size      = "10Gi"
  }
  
  # Priority class names
  priority_class_names = {
    mon = "system-node-critical"
    osd = "system-node-critical"
    mgr = "system-cluster-critical"
  }
  
  # Tolerations for control-plane nodes
  tolerations = [
    {
      effect   = "NoSchedule"
      key      = "node-role.kubernetes.io/control-plane"
      operator = "Exists"
    }
  ]
}