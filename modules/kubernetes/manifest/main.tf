resource "kubernetes_manifest" "this" {
  manifest        = var.manifest
  computed_fields = var.computed_fields
  wait            = var.wait

  dynamic "wait_condition" {
    for_each = var.wait_condition != null ? [var.wait_condition] : []
    content {
      status = wait_condition.value.status
      type   = wait_condition.value.type
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}