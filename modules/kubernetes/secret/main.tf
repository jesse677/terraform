terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
  }
}

resource "kubernetes_secret" "secret" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  type = var.type

  data        = var.data
 
}