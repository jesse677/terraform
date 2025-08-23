terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
}

provider "kubernetes" {
  host                   = var.kubernetes_server_endpoint
  config_path            = var.kubernetes_token == null ? var.kubernetes_config_path : null
  token                  = var.kubernetes_token != null ? var.kubernetes_token : null
  insecure               = true
}