terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      #version = ">=0.79.0"
      version = ">=0.111.0"
    }
  }
}

provider "proxmox" {
  insecure = true
}
