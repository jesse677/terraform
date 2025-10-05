include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "images-root" {
  path = find_in_parent_folders("images-root.hcl")
}

terraform {
  source = "../../../../modules/proxmox/images"
}

inputs = {
  url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  file_name    = "jammy-server-cloudimg-amd64-jellyfish.qcow2"
}