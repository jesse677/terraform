include "root" {
  path = find_in_parent_folders("k3s-root.hcl")
}

terraform {
  source = "../../../modules/kubernetes/helm-release"
}

locals {
  k3s_root = read_terragrunt_config("../k3s-root.hcl")
}

inputs = {
  # Kubernetes connection configuration
  kubernetes_server_endpoint = "https://${local.k3s_root.locals.k3s_server_ip}:6443"
  kubernetes_config_path    = "${pathexpand("~")}/.kube/config"
  
  # Helm release configuration
  name       = "adguard-home"
  repository = "https://k8s-at-home.com/charts/"
  chart      = "adguard-home"
  chart_version = "5.5.2"
  namespace  = "dns"
  create_namespace = true
  
  # Load values from local file
  values = [file("${get_terragrunt_dir()}/values.yaml")]
  
  # Helm options
  wait = true
  timeout = 600
  atomic = true
  cleanup_on_fail = true
}