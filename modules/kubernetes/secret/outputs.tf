output "secret_name" {
  description = "Name of the created secret"
  value       = kubernetes_secret.secret.metadata[0].name
}

output "secret_namespace" {
  description = "Namespace of the created secret"
  value       = kubernetes_secret.secret.metadata[0].namespace
}