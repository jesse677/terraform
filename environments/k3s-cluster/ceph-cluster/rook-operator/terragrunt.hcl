include "k3s_root" {
  path = "../../k3s-root.hcl"
}

terraform {
  source = "../../../../modules/kubernetes/rook-operator"
}

dependencies {
  paths = ["../../k3s-server-01"]
}

locals {
  k3s_root = read_terragrunt_config("../../k3s-root.hcl")
}

inputs = {
  # Kubernetes connection configuration
  kubernetes_server_endpoint = "https://${local.k3s_root.locals.k3s_server_ip}:6443"
  kubernetes_config_path    = "${pathexpand("~")}/.kube/config"
  
  # Rook operator configuration
  namespace = "rook-ceph"
  release_name = "rook-ceph"
  chart_version = "v1.15.5"
  log_level = "DEBUG"  # Use DEBUG for initial deployment troubleshooting
  
  # Temporarily disable discovery daemon to fix CSI issues
  enable_discovery_daemon = false
  
  # Tolerations for control-plane nodes
  tolerations = [
    {
      effect   = "NoSchedule"
      key      = "node-role.kubernetes.io/control-plane"
      operator = "Exists"
    }
  ]
}