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
  description = "Kubernetes namespace for Ceph cluster (must match Rook operator namespace)"
  type        = string
}

variable "cluster_name" {
  description = "Name of the Ceph cluster"
  type        = string
}

variable "ceph_version_image" {
  description = "Ceph container image version"
  type        = string
}

variable "allow_unsupported_version" {
  description = "Allow unsupported Ceph versions"
  type        = bool
  default     = false
}

variable "data_dir_host_path" {
  description = "Host path for Ceph data directory"
  type        = string
  default     = "/var/lib/rook"
}

variable "monitoring_enabled" {
  description = "Enable Ceph monitoring"
  type        = bool
  default     = true
}

variable "metrics_disabled" {
  description = "Disable metrics collection"
  type        = bool
  default     = false
}

variable "host_network" {
  description = "Use host networking for Ceph daemons"
  type        = bool
  default     = false
}

variable "dashboard_enabled" {
  description = "Enable Ceph dashboard"
  type        = bool
  default     = true
}

variable "dashboard_ssl" {
  description = "Enable SSL for Ceph dashboard"
  type        = bool
  default     = false
}

variable "crash_collector_disable" {
  description = "Disable crash collector"
  type        = bool
  default     = false
}

variable "log_collector_enabled" {
  description = "Enable log collector"
  type        = bool
  default     = true
}

variable "log_collector_periodicity" {
  description = "Log collection periodicity"
  type        = string
  default     = "daily"
}

variable "log_collector_max_log_size" {
  description = "Maximum log size for collection"
  type        = string
  default     = "500M"
}

variable "cleanup_policy_confirmation" {
  description = "Cleanup policy confirmation string"
  type        = string
  default     = ""
}

variable "sanitize_disks_method" {
  description = "Method for disk sanitization"
  type        = string
  default     = "quick"
}

variable "sanitize_disks_data_source" {
  description = "Data source for disk sanitization"
  type        = string
  default     = "zero"
}

variable "sanitize_disks_iteration" {
  description = "Number of sanitization iterations"
  type        = number
  default     = 1
}

variable "allow_uninstall_with_volumes" {
  description = "Allow uninstallation with existing volumes"
  type        = bool
  default     = false
}

variable "storage_nodes" {
  description = "List of storage nodes configuration"
  type = list(object({
    name = string
    devices = list(object({
      name = string
    }))
  }))
  default = []
}

variable "use_all_nodes" {
  description = "Use all available nodes for storage"
  type        = bool
  default     = false
}

variable "use_all_devices" {
  description = "Use all available devices for OSDs"
  type        = bool
  default     = false
}

variable "osds_per_device" {
  description = "Number of OSDs per device"
  type        = string
  default     = "1"
}

variable "encrypted_device" {
  description = "Enable device encryption"
  type        = string
  default     = "false"
}

variable "mon_count" {
  description = "Number of monitor daemons"
  type        = number
  default     = 3
}

variable "mon_allow_multiple_per_node" {
  description = "Allow multiple monitors per node"
  type        = bool
  default     = true
}

variable "mon_volume_claim_template" {
  description = "Volume claim template for monitors"
  type = object({
    storage_class_name = string
    storage_size      = string
  })
  default = null
}

variable "mgr_count" {
  description = "Number of manager daemons"
  type        = number
  default     = 2
}

variable "mgr_allow_multiple_per_node" {
  description = "Allow multiple managers per node"
  type        = bool
  default     = true
}

variable "osd_allow_multiple_per_node" {
  description = "Allow multiple OSDs per node"
  type        = bool
  default     = false
}

variable "resource_limits" {
  description = "Resource limits for Ceph daemons"
  type = object({
    mon = object({
      cpu    = string
      memory = string
    })
    osd = object({
      cpu    = string
      memory = string
    })
    mgr = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    mon = {
      cpu    = "1000m"
      memory = "1Gi"
    }
    osd = {
      cpu    = "1000m"
      memory = "2Gi"
    }
    mgr = {
      cpu    = "1000m"
      memory = "1Gi"
    }
  }
}

variable "resource_requests" {
  description = "Resource requests for Ceph daemons"
  type = object({
    mon = object({
      cpu    = string
      memory = string
    })
    osd = object({
      cpu    = string
      memory = string
    })
    mgr = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    mon = {
      cpu    = "100m"
      memory = "128Mi"
    }
    osd = {
      cpu    = "100m"
      memory = "512Mi"
    }
    mgr = {
      cpu    = "100m"
      memory = "128Mi"
    }
  }
}

variable "priority_class_names" {
  description = "Priority class names for Ceph daemons"
  type = object({
    mon = string
    osd = string
    mgr = string
  })
  default = null
}

variable "disruption_management_enabled" {
  description = "Enable disruption management"
  type        = bool
  default     = true
}

variable "disruption_management_namespace" {
  description = "Namespace for machine disruption budget"
  type        = string
  default     = null
}

variable "tolerations" {
  description = "Tolerations for all Ceph daemons"
  type = list(object({
    effect   = string
    key      = string
    operator = string
  }))
  default = []
}