variable "namespace" {
  description = "Kubernetes namespace for the Helm release"
  type        = string
  default     = "rook-ceph"
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = true
}

variable "namespace_labels" {
  description = "Labels for the namespace"
  type        = map(string)
  default     = {}
}

variable "namespace_annotations" {
  description = "Annotations for the namespace"
  type        = map(string)
  default     = {}
}

variable "release_name" {
  description = "Name of the Helm release"
  type        = string
  default     = "rook-ceph"
}

variable "helm_repository" {
  description = "Helm chart repository URL"
  type        = string
  default     = "https://charts.rook.io/release"
}

variable "chart_name" {
  description = "Name of the Helm chart"
  type        = string
  default     = "rook-ceph"
}

variable "chart_version" {
  description = "Version of the Helm chart"
  type        = string
  default     = null
}

variable "helm_values" {
  description = "List of Helm values in raw YAML format"
  type        = list(string)
  default     = []
}

variable "set_values" {
  description = "List of values to set via --set flag"
  type = list(object({
    name  = string
    value = string
    type  = optional(string)
  }))
  default = []
}

variable "set_sensitive_values" {
  description = "List of sensitive values to set via --set flag"
  type = list(object({
    name  = string
    value = string
    type  = optional(string)
  }))
  default   = []
  sensitive = true
}

variable "timeout" {
  description = "Time in seconds to wait for Helm release"
  type        = number
  default     = 300
}

variable "wait" {
  description = "Wait for release to be deployed"
  type        = bool
  default     = true
}

variable "wait_for_jobs" {
  description = "Wait for jobs to complete"
  type        = bool
  default     = true
}

variable "force_update" {
  description = "Force resource updates through deletion/recreation"
  type        = bool
  default     = false
}

variable "recreate_pods" {
  description = "Recreate pods on upgrade"
  type        = bool
  default     = false
}

variable "max_history" {
  description = "Maximum number of release versions to store"
  type        = number
  default     = 10
}

variable "atomic" {
  description = "Rollback on failure"
  type        = bool
  default     = false
}

variable "cleanup_on_fail" {
  description = "Clean up resources on failure"
  type        = bool
  default     = true
}

variable "reset_values" {
  description = "Reset values on upgrade"
  type        = bool
  default     = false
}

variable "reuse_values" {
  description = "Reuse values from previous release"
  type        = bool
  default     = false
}

variable "skip_crds" {
  description = "Skip CRD installation"
  type        = bool
  default     = false
}

variable "disable_openapi_validation" {
  description = "Disable OpenAPI validation"
  type        = bool
  default     = false
}