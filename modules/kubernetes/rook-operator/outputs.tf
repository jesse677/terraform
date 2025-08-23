output "namespace" {
  description = "The namespace where Rook operator is deployed"
  value       = kubernetes_namespace.rook_namespace.metadata[0].name
}

output "release_name" {
  description = "Helm release name of the Rook operator"
  value       = helm_release.rook_operator.name
}

output "release_status" {
  description = "Status of the Rook operator Helm release"
  value       = helm_release.rook_operator.status
}

output "chart_version" {
  description = "Version of the deployed Rook operator chart"
  value       = helm_release.rook_operator.version
}