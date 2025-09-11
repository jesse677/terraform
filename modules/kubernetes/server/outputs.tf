output "node_name" {
  description = "Name of the K3s server node"
  value       = var.node_name
}

output "internal_ip" {
  description = "Internal IP address of the node"
  value       = var.internal_ip
}

output "external_ip" {
  description = "External IP address of the node"
  value       = var.external_ip
}

output "ready" {
  description = "Whether the node is ready"
  value       = null_resource.wait_for_node.id != ""
}