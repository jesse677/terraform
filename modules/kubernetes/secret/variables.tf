variable "kubernetes_server_endpoint" {
  description = "The endpoint of the Kubernetes API server"
  type        = string
}

variable "kubernetes_config_path" {
  description = "Path to the kubeconfig file"
  type        = string
}

variable "name" {
  description = "Name of the secret"
  type        = string
}

variable "namespace" {
  description = "Namespace for the secret"
  type        = string
}

variable "type" {
  description = "Type of the secret"
  type        = string
  default     = "Opaque"
}

variable "data" {
  description = "Data for the secret (base64 encoded)"
  type        = map(string)
  default     = {}
}

variable "string_data" {
  description = "String data for the secret (will be base64 encoded automatically)"
  type        = map(string)
  default     = null
}