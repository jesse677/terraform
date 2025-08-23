terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
  }
}

provider "kubernetes" {
  host                   = var.kubernetes_server_endpoint
  config_path            = var.kubernetes_token == null ? var.kubernetes_config_path : null
  token                  = var.kubernetes_token != null ? var.kubernetes_token : null
  insecure               = true
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}