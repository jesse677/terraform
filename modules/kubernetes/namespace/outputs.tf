output "name" {
  description = "Name of the namespace"
  value       = kubernetes_namespace.this.metadata[0].name
}

output "uid" {
  description = "UID of the namespace"
  value       = kubernetes_namespace.this.metadata[0].uid
}

output "labels" {
  description = "Labels of the namespace"
  value       = kubernetes_namespace.this.metadata[0].labels
}

output "annotations" {
  description = "Annotations of the namespace"
  value       = kubernetes_namespace.this.metadata[0].annotations
}