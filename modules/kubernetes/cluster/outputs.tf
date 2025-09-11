output "cluster_token" {
  description = "K3s cluster join token"
  value       = local.k3s_token
  sensitive   = true
}

output "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  value       = "${path.module}/kubeconfig.yaml"
}

output "api_server_url" {
  description = "K3s API server URL"
  value       = "https://${local.first_server.external_ip}:6443"
}

output "cluster_cidr" {
  description = "Pod network CIDR"
  value       = var.cluster_cidr
}

output "service_cidr" {
  description = "Service network CIDR"
  value       = var.service_cidr
}

output "server_nodes" {
  description = "Server node details"
  value = {
    for k, v in var.server_nodes : k => {
      host        = v.host
      internal_ip = v.internal_ip
      external_ip = v.external_ip
    }
  }
}

output "agent_nodes" {
  description = "Agent node details"
  value = {
    for k, v in var.agent_nodes : k => {
      host        = v.host
      internal_ip = v.internal_ip
      external_ip = v.external_ip
    }
  }
}