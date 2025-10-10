include "root" {
  path = find_in_parent_folders("root.hcl")
}


terraform {
  source = "../../../../modules/proxmox/vm"
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("vms-root.hcl"))
  
  # Node-specific configuration
  node = {
    name    = "steam-server"
    proxmox = "pve-node-03"
    ip      = "192.168.20.2"        # Management/external network
  }
  
  # K3s node hardware requirements
  hardware = {
    cores    = 4        # 4 cores for K3s workloads
    memory   = 8192     # 8GB RAM for containers and services
    cpu_type = "x86-64-v2"
  }
  
  # Network interfaces for K3s node
  network_devices = [
    {
      bridge = "vmbr0"    # Management/external network
    }
  ]
}

inputs = {
  # Node identification
  name      = local.node.name
  node_name = local.node.proxmox
  
  # Hardware configuration
  cores    = local.hardware.cores
  memory   = local.hardware.memory
  cpu_type = local.hardware.cpu_type
  
  # Network configuration
  network_devices = local.network_devices
  ip_configs = [
    {
      address = "${local.node.ip}/24"
      gateway = local.root.locals.default_gateway
    }
  ]
  
  # Boot disk configuration - using template image from root.hcl
  boot_disk = local.root.locals.boot_disk
  
  # Additional data disks 
  additional_disks = [
    {
      datastore_id = "local-lvm"
      interface    = "scsi1"
      size         = 100
      file_format  = "raw"
    }
  ]
  
  # Cloud-init datastore
  cloud_init_datastore = local.root.locals.cloud_init_datastore
  
  # Authentication
  username = local.root.locals.vm_username
  password = local.root.locals.vm_password
  ssh_public_key_file = "~/.ssh/id_rsa.pub"
  
  # Cloud-init configuration  
  user_data = templatefile("../cloud-init.tftpl", {
    hostname = local.node.name
    packages = local.root.locals.base_packages
    username = local.root.locals.vm_username
    password = local.root.locals.vm_password
    ssh_key  = local.root.locals.ssh_public_key
  })
}