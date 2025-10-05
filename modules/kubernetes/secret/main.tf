resource "kubernetes_secret" "this" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    labels      = var.labels
    annotations = var.annotations
  }

  type = var.type
  data = merge(
    var.data,
    { for k, v in var.string_data : k => base64encode(v) }
  )
  immutable = var.immutable
}