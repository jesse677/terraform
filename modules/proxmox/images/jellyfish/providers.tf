terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.79.0"
    }
  }
}

provider "proxmox" {
  insecure = true
}
