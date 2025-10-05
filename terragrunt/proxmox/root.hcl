  remote_state {
    backend = "local"
    config = {
      path = "/mnt/c/proxmox/terraform-state/${path_relative_to_include()}/terraform.tfstate"
    }
  }