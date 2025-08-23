terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}


# Use existing namespace and elasticsearch deployment

# Deploy Kibana using Helm
resource "helm_release" "kibana" {
  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  version    = "8.5.1"
  namespace  = var.namespace

  values = [
    yamlencode({
      replicas = 1
      
      elasticsearchHosts = "http://elasticsearch-master:9200"
      
      kibanaConfig = {
        "kibana.yml" = "server.host: 0.0.0.0\nelasticsearch.hosts: [\"http://elasticsearch-master:9200\"]\nxpack.security.enabled: false\n"
      }
      
      resources = {
        requests = {
          cpu = "500m"
          memory = "1Gi"
        }
        limits = {
          cpu = "1000m"
          memory = "2Gi"
        }
      }
      
      service = {
        type = "ClusterIP"
        port = 5601
      }
      
      readinessProbe = {
        httpGet = {
          path = "/api/status"
          port = 5601
        }
        initialDelaySeconds = 30
        periodSeconds = 10
      }
      
      env = [
        {
          name = "XPACK_SECURITY_ENABLED"
          value = "false"
        }
      ]
    })
  ]

  # depends_on = [helm_release.elasticsearch] - using existing
}

# Create NodePort service for Kibana
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

  depends_on = [helm_release.kibana]
}

# Deploy Logstash using Helm
resource "helm_release" "logstash" {
  name       = "logstash"
  repository = "https://helm.elastic.co"
  chart      = "logstash"
  version    = "8.5.1"
  namespace  = var.namespace

  values = [
    yamlencode({
      replicas = 1
      
      logstashConfig = {
        "logstash.yml" = "http.host: 0.0.0.0\npath.config: /usr/share/logstash/pipeline\n"
      }
      
      logstashPipeline = {
        "logstash.conf" = <<EOT
input {
  beats {
    port => 5044
  }
  tcp {
    port => 5000
    codec => json
  }
  http {
    port => 8080
  }
}

filter {
  if [kubernetes] {
    mutate {
      add_field => { "cluster" => "k3s-cluster" }
    }
  }
  
  if [message] =~ /^\{.*\}$/ {
    json {
      source => "message"
    }
  }
  
  date {
    match => [ "@timestamp", "ISO8601" ]
  }
}

output {
  elasticsearch {
    hosts => ["http://elasticsearch-master:9200"]
    index => "k3s-logs-%%{+YYYY.MM.dd}"
  }
  stdout {
    codec => rubydebug
  }
}
EOT
      }
      
      resources = {
        requests = {
          cpu = "500m"
          memory = "1Gi"
        }
        limits = {
          cpu = "1000m"
          memory = "2Gi"
        }
      }
      
      logstashJavaOpts = "-Xms1g -Xmx1g"
      
      service = {
        type = "ClusterIP"
        ports = [
          {
            name = "beats"
            port = 5044
            protocol = "TCP"
            targetPort = 5044
          },
          {
            name = "tcp"
            port = 5000
            protocol = "TCP"
            targetPort = 5000
          },
          {
            name = "http"
            port = 8080
            protocol = "TCP"
            targetPort = 8080
          }
        ]
      }
    })
  ]

  # depends_on = [helm_release.elasticsearch] - using existing
}

# Deploy Filebeat using Helm
resource "helm_release" "filebeat" {
  name       = "filebeat"
  repository = "https://helm.elastic.co"
  chart      = "filebeat"
  version    = "8.5.1"
  namespace  = var.namespace

  values = [
    yamlencode({
      daemonset = {
        enabled = true
      }
      
      filebeatConfig = {
        "filebeat.yml" = <<EOT
filebeat.inputs:
- type: container
  paths:
    - /var/log/containers/*.log
  processors:
  - add_kubernetes_metadata:
      host: $${NODE_NAME}
      matchers:
      - logs_path:
          logs_path: "/var/log/containers/"

- type: log
  paths:
    - /var/log/syslog
    - /var/log/auth.log
  fields:
    logtype: system
    
output.logstash:
  hosts: ["logstash-logstash:5044"]
  
processors:
- add_host_metadata:
    when.not.contains.tags: forwarded
- add_cloud_metadata: ~
- add_docker_metadata: ~
- add_kubernetes_metadata: ~

logging.level: info
logging.to_files: false
logging.to_stderr: true
EOT
      }
      
      resources = {
        requests = {
          cpu = "100m"
          memory = "100Mi"
        }
        limits = {
          cpu = "200m"
          memory = "200Mi"
        }
      }
      
      securityContext = {
        runAsUser = 0
        capabilities = {
          add = ["DAC_READ_SEARCH"]
        }
      }
      
      extraVolumes = [
        {
          name = "varlibdockercontainers"
          hostPath = {
            path = "/var/lib/docker/containers"
          }
        },
        {
          name = "varlog"
          hostPath = {
            path = "/var/log"
          }
        },
        {
          name = "data"
          hostPath = {
            path = "/var/lib/filebeat-data"
            type = "DirectoryOrCreate"
          }
        }
      ]
      
      extraVolumeMounts = [
        {
          name = "varlibdockercontainers"
          mountPath = "/var/lib/docker/containers"
          readOnly = true
        },
        {
          name = "varlog"
          mountPath = "/var/log"
          readOnly = true
        },
        {
          name = "data"
          mountPath = "/usr/share/filebeat/data"
        }
      ]
      
      rbac = {
        create = true
      }
      
      hostNetwork = true
      dnsPolicy = "ClusterFirstWithHostNet"
      
      env = [
        {
          name = "NODE_NAME"
          valueFrom = {
            fieldRef = {
              fieldPath = "spec.nodeName"
            }
          }
        }
      ]
    })
  ]

  depends_on = [helm_release.logstash]
}

# Outputs
output "elasticsearch_service" {
  value = "elasticsearch-master.${var.namespace}.svc.cluster.local"
}

output "kibana_url" {
  value = "http://<node-ip>:30601"
}

output "namespace" {
  value = var.namespace
}