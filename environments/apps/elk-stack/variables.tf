variable "namespace" {
  description = "Kubernetes namespace for ELK stack"
  type        = string
}

variable "common_labels" {
  description = "Common labels for all resources"
  type        = map(string)
}