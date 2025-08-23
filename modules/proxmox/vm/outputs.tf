output "id" {
  description = "Full Proxmox resource ID in the form node/vmid"
  value       = proxmox_virtual_environment_vm.vm.id
}

output "name" {
  description = "Name of the VM"
  value       = var.name
}

output "ip_configs" {
  description = "List of IP configurations assigned to the VM"
  value       = var.ip_configs
}