output "name" {
  description = "Name of the ArgoCD application"
  value       = kubernetes_manifest.argocd_application.manifest.metadata.name
}

output "namespace" {
  description = "Namespace of the ArgoCD application"
  value       = kubernetes_manifest.argocd_application.manifest.metadata.namespace
}