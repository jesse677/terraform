output "pools" {
  description = "Created Proxmox pools, keyed by the same identifier as var.pools"
  value = {
    for key, pool in proxmox_virtual_environment_pool.pool : key => pool.pool_id
  }
}
