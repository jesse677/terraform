include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/proxmox/vm"
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("vms-root.hcl"))

  # Node-specific configuration
  # No static IP - HAOS uses DHCP, and the DHCP server handles DNS.
  node = {
    name    = "homeassistant"
    proxmox = "pve-node-01"          # wherever a USB dongle would eventually attach
  }

  hardware = {
    cores    = 4
    memory   = 4096
    cpu_type = "x86-64-v2"
  }

  # Network interfaces for Home Assistant
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

  # Home Assistant OS requires UEFI + q35, and has no cloud-init support -
  # it manages its own onboarding, storage, and networking.
  bios              = "ovmf"
  machine           = "q35"
  enable_cloud_init = false

  efi_disk = {
    datastore_id = "local-lvm"
  }

  # Boot disk imported from the HAOS OVA image (currently 18.1). The image
  # ships xz-compressed and must be downloaded + decompressed onto the
  # Proxmox host manually (Proxmox's importer doesn't support xz) before
  # this file_id resolves - see
  # https://github.com/home-assistant/operating-system/releases
  boot_disk = {
    datastore_id = "local-lvm"
    file_id      = "images:import/haos_ova-18.1.qcow2"
    interface    = "scsi0"
    size         = 32
    file_format  = "raw"
  }

  # Pool membership
  pool_id = "backup"
  
  # Cloud-init datastore (unused here since enable_cloud_init = false, kept
  # for parity with the other VM configs)
  cloud_init_datastore = local.root.locals.cloud_init_datastore
}
