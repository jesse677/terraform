variable "cluster_name" {
  description = "Name of the K3s cluster"
  type        = string
  default     = "k3s-cluster"
}

variable "cluster_domain" {
  description = "Cluster domain for K3s"
  type        = string
  default     = "cluster.local"
}

variable "cluster_cidr" {
  description = "CIDR for pod network"
  type        = string
  default     = "10.42.0.0/16"
}

variable "service_cidr" {
  description = "CIDR for service network"
  type        = string
  default     = "10.43.0.0/16"
}

variable "cluster_dns" {
  description = "Cluster DNS IP"
  type        = string
  default     = "10.43.0.10"
}

variable "disable_components" {
  description = "List of K3s components to disable"
  type        = list(string)
  default     = []
}

variable "k3s_version" {
  description = "K3s version to install"
  type        = string
  default     = "v1.30.4+k3s1"
}

variable "k3s_token" {
  description = "Token for K3s cluster join"
  type        = string
  sensitive   = true
  default     = ""
}

variable "generate_token" {
  description = "Whether to generate a random K3s token"
  type        = bool
  default     = true
}

variable "server_nodes" {
  description = "Map of server nodes with their configuration"
  type = map(object({
    host        = string
    internal_ip = string
    external_ip = string
    user        = string
    private_key = string
    labels      = optional(map(string), {})
    taints      = optional(list(string), [])
  }))
}

variable "agent_nodes" {
  description = "Map of agent nodes with their configuration"
  type = map(object({
    host        = string
    internal_ip = string
    external_ip = string
    user        = string
    private_key = string
    labels      = optional(map(string), {})
    taints      = optional(list(string), [])
  }))
  default = {}
}

variable "datastore_endpoint" {
  description = "External datastore endpoint for HA setup (e.g., MySQL, PostgreSQL, etcd)"
  type        = string
  default     = ""
}

variable "flannel_backend" {
  description = "Flannel backend type"
  type        = string
  default     = "vxlan"
}

variable "kube_proxy_args" {
  description = "Additional arguments for kube-proxy"
  type        = list(string)
  default     = []
}

variable "kubelet_args" {
  description = "Additional arguments for kubelet"
  type        = list(string)
  default     = []
}

variable "server_args" {
  description = "Additional arguments for K3s server"
  type        = list(string)
  default     = []
}

variable "agent_args" {
  description = "Additional arguments for K3s agent"
  type        = list(string)
  default     = []
}

variable "manifests_path" {
  description = "Path to custom manifests to deploy"
  type        = string
  default     = ""
}

variable "registry_mirrors" {
  description = "Container registry mirrors configuration"
  type = map(object({
    endpoint = list(string)
  }))
  default = {}
}