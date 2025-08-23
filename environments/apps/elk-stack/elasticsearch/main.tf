
# Create namespace
resource "kubernetes_namespace" "elk_stack" {
  metadata {
    name = var.namespace
    labels = var.common_labels
  }
}

# Deploy Elasticsearch using Helm
resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = var.elasticsearch_config.chart_version
  namespace  = kubernetes_namespace.elk_stack.metadata[0].name

  values = [file("${path.module}/values.yaml")]

  depends_on = [kubernetes_namespace.elk_stack]
}

output "elasticsearch_service" {
  value = "elasticsearch-master.${var.namespace}.svc.cluster.local"
}