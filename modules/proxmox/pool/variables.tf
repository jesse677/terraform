variable "pools" {
  description = "Proxmox resource pools to create, keyed by pool_id"
  type = map(object({
    comment = optional(string, "Managed by Terraform")
  }))
  default = {}
}
