output "name" {
  description = "Name of the Helm release"
  value       = helm_release.release.name
}

output "namespace" {
  description = "Namespace of the Helm release"
  value       = helm_release.release.namespace
}

output "version" {
  description = "Version of the Helm chart"
  value       = helm_release.release.version
}

output "chart" {
  description = "Chart name"
  value       = helm_release.release.chart
}

output "status" {
  description = "Status of the Helm release"
  value       = helm_release.release.status
}