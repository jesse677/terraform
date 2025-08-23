
# Deploy Kibana using Helm
resource "helm_release" "kibana" {
  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  version    = var.kibana_config.chart_version
  namespace  = var.namespace

  values = [templatefile("${path.module}/values.yaml", {
    elasticsearch_hosts = "http://${var.elasticsearch_hosts}:9200"
  })]
}

# Create NodePort service for external access
resource "kubernetes_service" "kibana_nodeport" {
  metadata {
    name      = "kibana-nodeport"
    namespace = var.namespace
    labels    = var.common_labels
  }

  spec {
    type = "NodePort"
    
    port {
      port        = 5601
      target_port = 5601
      node_port   = 30601
      protocol    = "TCP"
    }

    selector = {
      app = "kibana"
    }
  }
}

output "kibana_url" {
  value = "http://<node-ip>:30601"
}