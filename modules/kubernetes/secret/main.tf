resource "kubernetes_secret" "secret" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    labels      = var.labels
    annotations = var.annotations
  }

  type = var.type

  data        = var.data
  binary_data = var.binary_data

  dynamic "immutable" {
    for_each = var.immutable != null ? [var.immutable] : []
    content {
      immutable = immutable.value
    }
  }
}