output "object" {
  description = "The Kubernetes object created"
  value       = kubernetes_manifest.this.object
}

output "kind" {
  description = "Kind of the Kubernetes object"
  value       = kubernetes_manifest.this.object.kind
}

output "name" {
  description = "Name of the Kubernetes object"
  value       = kubernetes_manifest.this.object.metadata.name
}

output "namespace" {
  description = "Namespace of the Kubernetes object"
  value       = try(kubernetes_manifest.this.object.metadata.namespace, null)
}

output "uid" {
  description = "UID of the Kubernetes object"
  value       = kubernetes_manifest.this.object.metadata.uid
}