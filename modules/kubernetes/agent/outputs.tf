output "node_name" {
  description = "Name of the K3s agent node"
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
  description = "Whether the agent is ready"
  value       = null_resource.k3s_agent.id != ""
}