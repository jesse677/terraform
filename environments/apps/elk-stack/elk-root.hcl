locals {
  # ELK Stack Configuration
  elk_namespace = "elk-stack"
  
  # Elasticsearch Configuration
  elasticsearch = {
    chart_version = "8.5.1"
    replicas     = 1
    storage_size = "10Gi"
    storage_class = "rook-ceph-block"
    java_opts    = "-Xms1g -Xmx1g"
    resources = {
      requests = {
        cpu    = "500m"
        memory = "2Gi"
      }
      limits = {
        cpu    = "1000m"
        memory = "3Gi"
      }
    }
  }
  
  # Kibana Configuration
  kibana = {
    chart_version = "8.5.1"
    replicas     = 1
    resources = {
      requests = {
        cpu    = "500m"
        memory = "1Gi"
      }
      limits = {
        cpu    = "1000m"
        memory = "2Gi"
      }
    }
  }
  
  # Logstash Configuration
  logstash = {
    chart_version = "8.5.1"
    replicas     = 1
    resources = {
      requests = {
        cpu    = "500m"
        memory = "1Gi"
      }
      limits = {
        cpu    = "1000m"
        memory = "2Gi"
      }
    }
  }
  
  # Filebeat Configuration
  filebeat = {
    chart_version = "8.5.1"
    resources = {
      requests = {
        cpu    = "100m"
        memory = "100Mi"
      }
      limits = {
        cpu    = "200m"
        memory = "200Mi"
      }
    }
  }
  
  # Common labels
  common_labels = {
    "app.kubernetes.io/part-of" = "elk-stack"
    "environment" = "production"
    "managed-by" = "terragrunt"
  }
}

# Configure Terragrunt to automatically include this configuration in child configurations
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
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
EOF
}