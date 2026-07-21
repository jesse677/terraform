terraform {
  required_providers {
    technitium = {
      source = "registry.terraform.io/kevynb/technitium"
    }
  }
}

provider "technitium" {
  url   = var.technitium_url
  token = var.technitium_token
}