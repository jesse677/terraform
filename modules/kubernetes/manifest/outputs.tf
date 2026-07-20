output "applied" {
  description = "Identifiers of the manifests applied"
  value       = keys(kubernetes_manifest.this)
}
