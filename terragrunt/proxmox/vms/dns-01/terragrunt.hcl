include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/proxmox/vm"
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("vms-root.hcl"))
  dns  = read_terragrunt_config(find_in_parent_folders("dns-root.hcl"))

  # Node-specific configuration
  node = {
    name    = "dns-01"
    proxmox = "pve-node-01"
    ip      = "192.168.20.11"        # Technitium primary
  }
}

inputs = {
  # Node identification
  name      = local.node.name
  node_name = local.node.proxmox

  # Hardware configuration
  cores    = local.dns.locals.hardware.cores
  memory   = local.dns.locals.hardware.memory
  cpu_type = local.dns.locals.hardware.cpu_type

  # Network configuration
  network_devices = local.dns.locals.network_devices
  ip_configs = [
    {
      address = "${local.node.ip}/24"
      gateway = local.root.locals.default_gateway
    }
  ]

  # Boot disk configuration - shared template image, small DNS-sized disk
  boot_disk = merge(local.root.locals.boot_disk, { size = local.dns.locals.boot_disk_size })

  # Cloud-init datastore
  cloud_init_datastore = local.root.locals.cloud_init_datastore

  # Authentication
  username = local.root.locals.vm_username
  password = local.root.locals.vm_password
  ssh_public_key_file = "~/.ssh_linux/id_ed25519.pub"

  # Cloud-init configuration
  user_data = templatefile("../cloud-init-dns.tftpl", {
    hostname = local.node.name
    packages = local.root.locals.base_packages
    username = local.root.locals.vm_username
    password = local.root.locals.vm_password
    ssh_key  = local.root.locals.ssh_public_key
  })
}
