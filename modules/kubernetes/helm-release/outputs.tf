output "id" {
  description = "ID of the Helm release"
  value       = helm_release.this.id
}

output "name" {
  description = "Name of the Helm release"
  value       = helm_release.this.name
}

output "namespace" {
  description = "Namespace of the Helm release"
  value       = helm_release.this.namespace
}

output "status" {
  description = "Status of the Helm release"
  value       = helm_release.this.status
}

output "version" {
  description = "Version of the deployed Helm chart"
  value       = helm_release.this.version
}

output "values" {
  description = "The compounded values used for the release"
  value       = helm_release.this.values
  sensitive   = true
}