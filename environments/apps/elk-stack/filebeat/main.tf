
# Deploy Filebeat using Helm
resource "helm_release" "filebeat" {
  name       = "filebeat"
  repository = "https://helm.elastic.co"
  chart      = "filebeat"
  version    = var.filebeat_config.chart_version
  namespace  = var.namespace

  values = [templatefile("${path.module}/values.yaml", {
    logstash_hosts = "${var.logstash_hosts}:5044"
  })]
}

output "filebeat_daemonset" {
  value = "filebeat-filebeat deployed as DaemonSet"
}