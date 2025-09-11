variable "node_name" {
  description = "Name of the K3s server node"
  type        = string
}

variable "host" {
  description = "Hostname or IP address of the server"
  type        = string
}

variable "internal_ip" {
  description = "Internal/cluster IP address"
  type        = string
}

variable "external_ip" {
  description = "External/management IP address"
  type        = string
}

variable "user" {
  description = "SSH user for the server"
  type        = string
}

variable "private_key" {
  description = "Path to SSH private key"
  type        = string
}

variable "k3s_version" {
  description = "K3s version to install"
  type        = string
}

variable "k3s_args" {
  description = "Arguments for K3s server"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Node labels"
  type        = map(string)
  default     = {}
}

variable "taints" {
  description = "Node taints"
  type        = list(string)
  default     = []
}

variable "is_first" {
  description = "Whether this is the first server node"
  type        = bool
  default     = false
}

variable "install_timeout" {
  description = "Timeout for K3s installation"
  type        = string
  default     = "600s"
}