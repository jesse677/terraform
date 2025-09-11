output "manifest" {
  description = "The applied Kubernetes manifest"
  value       = kubernetes_manifest.manifest.manifest
}

output "name" {
  description = "Name of the created resource"
  value       = try(kubernetes_manifest.manifest.manifest.metadata.name, null)
}

output "namespace" {
  description = "Namespace of the created resource"
  value       = try(kubernetes_manifest.manifest.manifest.metadata.namespace, null)
}