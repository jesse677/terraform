resource "kubernetes_config_map" "this" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    labels      = var.labels
    annotations = var.annotations
  }

  data        = var.data
  binary_data = var.binary_data
  immutable   = var.immutable
}