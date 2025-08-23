variable "namespace" {
  description = "Kubernetes namespace for ELK stack"
  type        = string
}

variable "elasticsearch_config" {
  description = "Elasticsearch configuration"
  type        = any
}

variable "common_labels" {
  description = "Common labels for all resources"
  type        = map(string)
}