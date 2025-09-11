variable "name" {
  description = "Name of the VM in Proxmox"
  type        = string
}

variable "vm_id" {
  description = "VM ID in Proxmox (optional, will be auto-assigned if not specified)"
  type        = number
  default     = null
}

variable "node_name" {
  description = "Proxmox node (host) to deploy the VM on"
  type        = string
}

# Backward compatibility
variable "node" {
  description = "Proxmox node (host) to deploy the VM on (deprecated, use node_name)"
  type        = string
  default     = null
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "cpu_type" {
  description = "CPU type for the VM"
  type        = string
  default     = "host"
}

variable "memory" {
  description = "Memory (MB) for the VM"
  type        = number
  default     = 4096
}

variable "disks" {
  description = "List of disks to attach to the VM (deprecated - use boot_disk and additional_disks)"
  type = list(object({
    datastore_id = string
    file_id      = optional(string)
    interface    = string
    size         = number
    file_format  = optional(string)
  }))
  default = []
}

variable "template_id" {
  description = "VM ID of the template to clone from (use this OR boot_disk, not both)"
  type        = number
  default     = null
}

variable "boot_disk" {
  description = "Boot disk configuration when not cloning from template"
  type = object({
    datastore_id = string
    file_id      = optional(string)
    interface    = optional(string)
    size         = number
    file_format  = optional(string)
  })
  default = null
}

variable "boot_disk_datastore" {
  description = "Datastore for boot disk when cloning from template"
  type        = string
  default     = "local-lvm"
}

variable "boot_disk_size" {
  description = "Size of boot disk in GB when cloning from template"
  type        = number
  default     = null
}

variable "additional_disks" {
  description = "List of additional data disks to attach to the VM"
  type = list(object({
    datastore_id = string
    interface    = string
    size         = number
    file_format  = optional(string)
  }))
  default = []
}

variable "network_devices" {
  description = "List of network devices for the VM"
  type = list(object({
    bridge  = string
    vlan_id = optional(number)
  }))
  default = []
}

variable "ip_configs" {
  description = "List of IP configurations for network interfaces"
  type = list(object({
    address = string
    gateway = optional(string)
  }))
  default = []
}

variable "ssh_keys" {
  description = "List of SSH public keys"
  type        = list(string)
  default     = []
}

variable "ssh_public_key_file" {
  description = "Path to SSH public key file (takes precedence over ssh_keys)"
  type        = string
  default     = null
}

variable "password" {
  description = "Password for the user account"
  type        = string
  sensitive   = true
  default     = null
}

variable "username" {
  description = "Username for the user account"
  type        = string
  default     = "ubuntu"
}

variable "os_type" {
  description = "Type for operating system"
  type        = string
  default     = "l26"
}


variable "datastore_id" {
  description = "Datastore ID to store cloud-init files"
  type        = string
  default     = "local"
}

variable "user_data" {
  description = "Cloud-init user data YAML content"
  type        = string
  default     = null
}

variable "vendor_data" {
  description = "Cloud-init vendor data YAML content"
  type        = string
  default     = null
}

variable "network_data" {
  description = "Cloud-init network data YAML content"
  type        = string
  default     = null
}

variable "user_data_file_id" {
  description = "External cloud-init user data file ID (takes precedence over user_data)"
  type        = string
  default     = null
}

variable "vendor_data_file_id" {
  description = "External cloud-init vendor data file ID (takes precedence over vendor_data)"
  type        = string
  default     = null
}

variable "network_data_file_id" {
  description = "External cloud-init network data file ID (takes precedence over network_data)"
  type        = string
  default     = null
}

# Backward compatibility
variable "cloud_init_user_data" {
  description = "Cloud-init user data YAML content (deprecated, use user_data)"
  type        = string
  default     = null
}

variable "cloud_init_datastore" {
  description = "Datastore to store cloud-init files (deprecated, use datastore_id)"
  type        = string
  default     = "jtdt01-images"
}

# High Availability Configuration
variable "ha_enabled" {
  description = "Enable High Availability for this VM"
  type        = bool
  default     = false
}

variable "ha_group" {
  description = "Name of the HA group this VM belongs to"
  type        = string
  default     = null
}

variable "ha_state" {
  description = "Desired HA state (started, stopped, ignored)"
  type        = string
  default     = "started"
  validation {
    condition     = contains(["started", "stopped", "ignored"], var.ha_state)
    error_message = "HA state must be one of: started, stopped, ignored."
  }
}

variable "ha_max_restart" {
  description = "Maximum number of restart attempts"
  type        = number
  default     = 3
}

variable "ha_max_relocate" {
  description = "Maximum number of relocation attempts"
  type        = number
  default     = 3
}

variable "ha_comment" {
  description = "Comment for the HA resource"
  type        = string
  default     = "Managed by Terraform"
}