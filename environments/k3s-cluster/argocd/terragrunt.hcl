include "root" {
  path = find_in_parent_folders("k3s-root.hcl")
}

terraform {
  source = "../../../modules/kubernetes/helm-release"
}

dependency "admin_secret" {
  config_path = "./argocd-admin-secret"
  skip_outputs = true
}

locals {
  k3s_root = read_terragrunt_config("../k3s-root.hcl")
}

inputs = {
  # Kubernetes connection configuration
  kubernetes_server_endpoint = "https://${local.k3s_root.locals.k3s_server_ip}:6443"
  kubernetes_config_path    = "${pathexpand("~")}/.kube/config"
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.7.12"
  namespace  = "argocd"
  values     = [file("${get_terragrunt_dir()}/values.yaml")]
}