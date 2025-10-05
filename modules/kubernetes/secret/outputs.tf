output "name" {
  description = "Name of the secret"
  value       = kubernetes_secret.this.metadata[0].name
}

output "namespace" {
  description = "Namespace of the secret"
  value       = kubernetes_secret.this.metadata[0].namespace
}

output "uid" {
  description = "UID of the secret"
  value       = kubernetes_secret.this.metadata[0].uid
}

output "type" {
  description = "Type of the secret"
  value       = kubernetes_secret.this.type
}