variable "name" {
  description = "Name of the secret"
  type        = string
}

variable "namespace" {
  description = "Namespace for the secret"
  type        = string
  default     = "default"
}

variable "type" {
  description = "Type of the secret (e.g., Opaque, kubernetes.io/service-account-token)"
  type        = string
  default     = "Opaque"
}

variable "data" {
  description = "Data for the secret (base64 encoded)"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "binary_data" {
  description = "Binary data for the secret"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "labels" {
  description = "Labels to apply to the secret"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations to apply to the secret"
  type        = map(string)
  default     = {}
}

variable "immutable" {
  description = "If set to true, ensures that data stored in the Secret cannot be updated"
  type        = bool
  default     = null
}