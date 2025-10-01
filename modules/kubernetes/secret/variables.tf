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
  description = "Type of the secret"
  type        = string
  default     = "Opaque"
}

variable "data" {
  description = "Map of secret data (base64 encoded)"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "string_data" {
  description = "Map of secret data (plain text - will be base64 encoded)"
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
  description = "Whether the secret is immutable"
  type        = bool
  default     = false
}