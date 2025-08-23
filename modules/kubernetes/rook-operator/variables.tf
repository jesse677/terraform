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

variable "namespace" {
  description = "Kubernetes namespace for Rook operator"
  type        = string
}

variable "release_name" {
  description = "Helm release name"
  type        = string
}

variable "chart_version" {
  description = "Rook-Ceph Helm chart version"
  type        = string
}

variable "helm_repository" {
  description = "Rook Helm chart repository URL"
  type        = string
  default     = "https://charts.rook.io/release"
}

variable "enable_discovery_daemon" {
  description = "Enable Rook discovery daemon"
  type        = bool
  default     = true
}

variable "enable_crds" {
  description = "Enable CRDs installation"
  type        = bool
  default     = true
}

variable "enable_rbd_driver" {
  description = "Enable RBD CSI driver"
  type        = bool
  default     = true
}

variable "enable_cephfs_driver" {
  description = "Enable CephFS CSI driver"
  type        = bool
  default     = true
}

variable "log_level" {
  description = "Rook operator log level"
  type        = string
  default     = "INFO"
  validation {
    condition     = contains(["DEBUG", "INFO", "WARN", "ERROR"], var.log_level)
    error_message = "Log level must be one of: DEBUG, INFO, WARN, ERROR."
  }
}

variable "resource_limits_cpu" {
  description = "CPU resource limits for Rook operator"
  type        = string
  default     = "500m"
}

variable "resource_limits_memory" {
  description = "Memory resource limits for Rook operator"
  type        = string
  default     = "512Mi"
}

variable "tolerations" {
  description = "List of tolerations for discovery daemon"
  type = list(object({
    effect   = string
    key      = string
    operator = string
  }))
  default = []
}

variable "helm_values" {
  description = "Additional Helm values as YAML string"
  type        = string
  default     = null
}