provider "kubernetes" {
  host                   = var.kubernetes_server_endpoint
  config_path            = var.kubernetes_config_path
}