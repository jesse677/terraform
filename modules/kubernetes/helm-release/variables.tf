variable "kubernetes_server_endpoint" {
  description = "Kubernetes API server endpoint"
  type        = string
}

variable "kubernetes_token" {
  description = "Kubernetes authentication token"
  type        = string
  default     = null
}

variable "kubernetes_config_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}


variable "name" {
  description = "Name of the Helm release"
  type        = string
}

variable "repository" {
  description = "Helm repository URL"
  type        = string
}

variable "chart" {
  description = "Name of the Helm chart"
  type        = string
}

variable "chart_version" {
  description = "Version of the Helm chart"
  type        = string
  default     = null
}

variable "namespace" {
  description = "Kubernetes namespace to install the chart into"
  type        = string
}

variable "create_namespace" {
  description = "Create namespace if it doesn't exist"
  type        = bool
  default     = true
}

variable "values" {
  description = "List of values files or values as strings"
  type        = list(string)
  default     = []
}

variable "set" {
  description = "Custom values to set"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "set_sensitive" {
  description = "Custom sensitive values to set"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "timeout" {
  description = "Timeout for Helm operations"
  type        = number
  default     = 300
}

variable "wait" {
  description = "Wait for all resources to be ready"
  type        = bool
  default     = true
}

variable "wait_for_jobs" {
  description = "Wait for all jobs to complete"
  type        = bool
  default     = false
}

variable "force_update" {
  description = "Force resource update through delete/recreate"
  type        = bool
  default     = false
}

variable "recreate_pods" {
  description = "Perform pods restart during upgrade/rollback"
  type        = bool
  default     = false
}

variable "max_history" {
  description = "Maximum number of release revisions saved per release"
  type        = number
  default     = 10
}

variable "verify" {
  description = "Verify the package before installing"
  type        = bool
  default     = false
}

variable "keyring" {
  description = "Location of public keys used for verification"
  type        = string
  default     = ""
}

variable "repository_key_file" {
  description = "The repositories cert key file"
  type        = string
  default     = ""
}

variable "repository_cert_file" {
  description = "The repositories cert file"
  type        = string
  default     = ""
}

variable "repository_ca_file" {
  description = "The repositories CA Bundle file"
  type        = string
  default     = ""
}

variable "repository_username" {
  description = "Username for HTTP basic authentication"
  type        = string
  default     = ""
}

variable "repository_password" {
  description = "Password for HTTP basic authentication"
  type        = string
  default     = ""
  sensitive   = true
}

variable "devel" {
  description = "Use development versions"
  type        = bool
  default     = false
}

variable "dependency_update" {
  description = "Run helm dependency update before installing the chart"
  type        = bool
  default     = false
}

variable "disable_webhooks" {
  description = "Prevent hooks from running"
  type        = bool
  default     = false
}

variable "reset_values" {
  description = "Reset values to default when upgrading"
  type        = bool
  default     = false
}

variable "reuse_values" {
  description = "Reuse the last release's values"
  type        = bool
  default     = false
}

variable "cleanup_on_fail" {
  description = "Delete new resources created in this upgrade when upgrade fails"
  type        = bool
  default     = false
}

variable "atomic" {
  description = "If set, installation process purges chart on fail"
  type        = bool
  default     = false
}

variable "skip_crds" {
  description = "Skip CRDs during install"
  type        = bool
  default     = false
}

variable "render_subchart_notes" {
  description = "Render subchart notes"
  type        = bool
  default     = true
}

variable "disable_openapi_validation" {
  description = "Disable OpenAPI validation"
  type        = bool
  default     = false
}

variable "description" {
  description = "Description for the release"
  type        = string
  default     = ""
}

variable "postrender" {
  description = "Configure a command to run after helm renders the manifest"
  type = object({
    binary_path = string
  })
  default = null
}

variable "lint" {
  description = "Run helm lint when planning"
  type        = bool
  default     = false
}