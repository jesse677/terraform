resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace ? 1 : 0
  
  metadata {
    name        = var.namespace
    labels      = var.namespace_labels
    annotations = var.namespace_annotations
  }
}

resource "helm_release" "rook_operator" {
  name                       = var.release_name
  namespace                  = var.namespace
  repository                 = var.helm_repository
  chart                      = var.chart_name
  version                    = var.chart_version
  values                     = var.helm_values
  timeout                    = var.timeout
  wait                       = var.wait
  wait_for_jobs             = var.wait_for_jobs
  force_update              = var.force_update
  recreate_pods             = var.recreate_pods
  max_history               = var.max_history
  atomic                    = var.atomic
  cleanup_on_fail           = var.cleanup_on_fail
  reset_values              = var.reset_values
  reuse_values              = var.reuse_values
  skip_crds                 = var.skip_crds
  disable_openapi_validation = var.disable_openapi_validation

  dynamic "set" {
    for_each = var.set_values
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }

  dynamic "set_sensitive" {
    for_each = var.set_sensitive_values
    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
      type  = lookup(set_sensitive.value, "type", null)
    }
  }

  depends_on = [kubernetes_namespace.namespace]
}