variable "namespace" {
  description = "Kubernetes namespace for ELK stack"
  type        = string
}

variable "kibana_config" {
  description = "Kibana configuration"
  type        = any
}

variable "common_labels" {
  description = "Common labels for all resources"
  type        = map(string)
}

variable "elasticsearch_hosts" {
  description = "Elasticsearch service hostname"
  type        = string
}