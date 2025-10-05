variable "manifest" {
  description = "Kubernetes manifest in HCL format"
  type        = any
}

variable "computed_fields" {
  description = "List of computed fields to ignore during planning"
  type        = list(string)
  default     = ["metadata.annotations", "metadata.labels"]
}

variable "wait" {
  description = "Wait for the manifest to be fully deployed"
  type        = bool
  default     = true
}

variable "wait_condition" {
  description = "Condition to wait for"
  type = object({
    status = optional(string)
    type   = optional(string)
  })
  default = null
}

variable "timeouts" {
  description = "Timeout configuration"
  type = object({
    create = optional(string, "10m")
    update = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {}
}