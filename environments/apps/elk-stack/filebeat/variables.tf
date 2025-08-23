variable "namespace" {
  description = "Kubernetes namespace for ELK stack"
  type        = string
}

variable "filebeat_config" {
  description = "Filebeat configuration"
  type        = any
}

variable "common_labels" {
  description = "Common labels for all resources"
  type        = map(string)
}

variable "logstash_hosts" {
  description = "Logstash service hostname"
  type        = string
}