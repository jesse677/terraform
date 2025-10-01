variable "name" {
  description = "Name of the ConfigMap"
  type        = string
}

variable "namespace" {
  description = "Namespace for the ConfigMap"
  type        = string
  default     = "default"
}

variable "data" {
  description = "Map of ConfigMap data"
  type        = map(string)
  default     = {}
}

variable "binary_data" {
  description = "Map of binary data for the ConfigMap (base64 encoded)"
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Labels to apply to the ConfigMap"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations to apply to the ConfigMap"
  type        = map(string)
  default     = {}
}

variable "immutable" {
  description = "Whether the ConfigMap is immutable"
  type        = bool
  default     = false
}