resource "proxmox_virtual_environment_file" "cloud_config_user_data" {
  count        = local.user_data != null ? 1 : 0
  content_type = "snippets"
  datastore_id = local.datastore_id
  node_name    = local.node_name
  
  source_raw {
    data      = local.user_data
    file_name = "${var.name}-user-data.yml"
  }
}

resource "proxmox_virtual_environment_file" "cloud_config_vendor_data" {
  count        = var.vendor_data != null ? 1 : 0
  content_type = "snippets"
  datastore_id = local.datastore_id
  node_name    = local.node_name
  
  source_raw {
    data      = var.vendor_data
    file_name = "${var.name}-vendor-data.yml"
  }
}

resource "proxmox_virtual_environment_file" "cloud_config_network_data" {
  count        = var.network_data != null ? 1 : 0
  content_type = "snippets"
  datastore_id = local.datastore_id
  node_name    = local.node_name
  
  source_raw {
    data      = var.network_data
    file_name = "${var.name}-network-data.yml"
  }
}

data "local_file" "ssh_public_key" {
  count    = var.ssh_public_key_file != null ? 1 : 0
  filename = pathexpand(var.ssh_public_key_file)
}

locals {
  node_name    = var.node_name != null ? var.node_name : var.node
  datastore_id = var.datastore_id != "local" ? var.datastore_id : var.cloud_init_datastore
  user_data    = var.user_data != null ? var.user_data : var.cloud_init_user_data
  ssh_keys     = var.ssh_public_key_file != null ? [trimspace(data.local_file.ssh_public_key[0].content)] : var.ssh_keys
}

resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.name
  vm_id       = var.vm_id
  node_name   = local.node_name
  tags        = ["terraform"]

  agent {
    enabled = true
  }

  cpu {
    cores = var.cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory
  }

  dynamic "disk" {
    for_each = var.disks
    content {
      datastore_id = disk.value.datastore_id
      file_id      = lookup(disk.value, "file_id", null)
      interface    = disk.value.interface
      size         = disk.value.size
      file_format  = lookup(disk.value, "file_format", "raw")
    }
  }

  dynamic "network_device" {
    for_each = var.network_devices
    content {
      bridge  = network_device.value.bridge
      vlan_id = network_device.value.vlan_id
    }
  }

  initialization {
    dynamic "ip_config" {
      for_each = var.ip_configs
      content {
        ipv4 {
          address = ip_config.value.address
          gateway = ip_config.value.gateway
        }
      }
    }

    user_account {
      keys     = local.ssh_keys
      password = var.password
      username = var.username
    }

    user_data_file_id    = local.user_data != null ? proxmox_virtual_environment_file.cloud_config_user_data[0].id : var.user_data_file_id
    vendor_data_file_id  = var.vendor_data != null ? proxmox_virtual_environment_file.cloud_config_vendor_data[0].id : var.vendor_data_file_id
    network_data_file_id = var.network_data != null ? proxmox_virtual_environment_file.cloud_config_network_data[0].id : var.network_data_file_id
  }

  operating_system {
    type = var.os_type
  }
}

# High Availability resource (optional)
resource "proxmox_virtual_environment_haresource" "vm_ha" {
  count       = var.ha_enabled ? 1 : 0
  resource_id = "vm:${proxmox_virtual_environment_vm.vm.vm_id}"
  group       = var.ha_group
  state       = var.ha_state
  max_restart = var.ha_max_restart
  max_relocate = var.ha_max_relocate
  comment     = var.ha_comment

  depends_on = [proxmox_virtual_environment_vm.vm]
}
   
