
resource "kubernetes_manifest" "manifest" {
  manifest = var.manifest
}