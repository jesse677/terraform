resource "helm_release" "this" {
  name             = var.name
  namespace        = var.namespace
  repository       = var.repository
  chart            = var.chart
  version          = var.chart_version
  create_namespace = var.create_namespace
  wait             = var.wait
  timeout          = var.timeout
  cleanup_on_fail  = var.cleanup_on_fail
  force_update     = var.force_update
  recreate_pods    = var.recreate_pods
  max_history      = var.max_history

  values = var.values
}