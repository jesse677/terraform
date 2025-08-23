
resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace ? 1 : 0
  
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "release" {
  name                       = var.name
  repository                 = var.repository
  chart                      = var.chart
  version                    = var.chart_version
  namespace                  = var.namespace
  values                     = var.values
  timeout                    = var.timeout
  wait                       = var.wait
  wait_for_jobs             = var.wait_for_jobs
  force_update              = var.force_update
  recreate_pods             = var.recreate_pods
  max_history               = var.max_history
  verify                    = var.verify
  keyring                   = var.keyring
  repository_key_file       = var.repository_key_file
  repository_cert_file      = var.repository_cert_file
  repository_ca_file        = var.repository_ca_file
  repository_username       = var.repository_username
  repository_password       = var.repository_password
  devel                     = var.devel
  dependency_update         = var.dependency_update
  disable_webhooks          = var.disable_webhooks
  reset_values              = var.reset_values
  reuse_values              = var.reuse_values
  cleanup_on_fail           = var.cleanup_on_fail
  atomic                    = var.atomic
  skip_crds                 = var.skip_crds
  render_subchart_notes     = var.render_subchart_notes
  disable_openapi_validation = var.disable_openapi_validation
  description               = var.description
  lint                      = var.lint

  dynamic "set" {
    for_each = var.set
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  dynamic "set_sensitive" {
    for_each = var.set_sensitive
    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
    }
  }

  dynamic "postrender" {
    for_each = var.postrender != null ? [var.postrender] : []
    content {
      binary_path = postrender.value.binary_path
    }
  }

  depends_on = [kubernetes_namespace.namespace]
}