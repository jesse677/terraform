output "cluster_name" {
  description = "Name of the deployed Ceph cluster"
  value       = kubernetes_manifest.ceph_cluster.manifest.metadata.name
}

output "namespace" {
  description = "Namespace where Ceph cluster is deployed"
  value       = kubernetes_manifest.ceph_cluster.manifest.metadata.namespace
}

output "cluster_manifest" {
  description = "Full Kubernetes manifest for the Ceph cluster"
  value       = kubernetes_manifest.ceph_cluster.manifest
}