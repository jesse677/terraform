variable "name" {
  description = "Name of the Helm release"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace to deploy the release"
  type        = string
}

variable "repository" {
  description = "Helm chart repository URL"
  type        = string
}

variable "chart" {
  description = "Helm chart name"
  type        = string
}

variable "chart_version" {
  description = "Version of the Helm chart"
  type        = string
  default     = null
}

variable "values" {
  description = "Values to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "set" {
  description = "Value pairs to set for the Helm chart"
  type = list(object({
    name  = string
    value = string
    type  = optional(string)
  }))
  default = []
}

variable "set_sensitive" {
  description = "Sensitive value pairs to set for the Helm chart"
  type = list(object({
    name  = string
    value = string
    type  = optional(string)
  }))
  default   = []
  sensitive = true
}

variable "create_namespace" {
  description = "Create the namespace if it does not exist"
  type        = bool
  default     = false
}

variable "wait" {
  description = "Wait for the release to be deployed"
  type        = bool
  default     = true
}

variable "timeout" {
  description = "Time in seconds to wait for the release"
  type        = number
  default     = 300
}

variable "cleanup_on_fail" {
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
  default     = true
}

variable "force_update" {
  description = "Force resource update through delete/recreate"
  type        = bool
  default     = false
}

variable "recreate_pods" {
  description = "Recreate pods when upgrading"
  type        = bool
  default     = false
}

variable "max_history" {
  description = "Maximum number of release versions stored"
  type        = number
  default     = 10
}