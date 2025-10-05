output "name" {
  description = "Name of the ConfigMap"
  value       = kubernetes_config_map.this.metadata[0].name
}

output "namespace" {
  description = "Namespace of the ConfigMap"
  value       = kubernetes_config_map.this.metadata[0].namespace
}

output "uid" {
  description = "UID of the ConfigMap"
  value       = kubernetes_config_map.this.metadata[0].uid
}

output "data" {
  description = "Data stored in the ConfigMap"
  value       = kubernetes_config_map.this.data
}