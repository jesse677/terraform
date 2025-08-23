
# Deploy Logstash using Helm
resource "helm_release" "logstash" {
  name       = "logstash"
  repository = "https://helm.elastic.co"
  chart      = "logstash"
  version    = var.logstash_config.chart_version
  namespace  = var.namespace

  values = [templatefile("${path.module}/values.yaml", {
    elasticsearch_hosts = "http://${var.elasticsearch_hosts}:9200"
  })]
}

output "logstash_service" {
  value = "logstash-logstash.${var.namespace}.svc.cluster.local"
}