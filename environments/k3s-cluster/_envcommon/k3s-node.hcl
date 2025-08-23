locals {
  root = read_terragrunt_config(find_in_parent_folders("k3s-root.hcl"))
}

# Common inputs for all K3s nodes
inputs = {
  cores                 = local.root.locals.vm_cores
  memory                = local.root.locals.vm_memory
  cpu_type              = local.root.locals.vm_cpu_type
  username              = local.root.locals.vm_username
  password              = local.root.locals.vm_password
  ssh_public_key_file   = local.root.locals.ssh_public_key_file
  datastore_id          = local.root.locals.cloud_init_datastore
  disks                 = local.root.locals.disks
  network_devices       = local.root.locals.network_devices
}