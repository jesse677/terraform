include "root" {
  path = find_in_parent_folders("k3s-root.hcl")
}

terraform {
  source = "../../../../modules/kubernetes/secret"
}

locals {
  k3s_root = read_terragrunt_config("../../k3s-root.hcl")
  # Use environment variable ARGOCD_ADMIN_PASSWORD or default to a placeholder
  admin_password = get_env("ARGOCD_ADMIN_PASSWORD", "changeme-set-ARGOCD_ADMIN_PASSWORD-env")
}

inputs = {
  # Kubernetes connection configuration
  kubernetes_server_endpoint = "https://${local.k3s_root.locals.k3s_server_ip}:6443"
  kubernetes_config_path    = "${pathexpand("~")}/.kube/config"
  
  name      = "argocd-secret"
  namespace = "argocd"
  type      = "Opaque"
  
  string_data = {
    password = local.admin_password
  }
}