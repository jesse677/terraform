# All Proxmox resource pools, keyed by pool_id. Add new pools here -
# terragrunt.hcl in this directory turns every entry into a
# proxmox_virtual_environment_pool resource, so this is the only file that
# needs to change. Reference a pool from a VM by setting pool_id in the VM's
# terragrunt.hcl to the same key used here.
locals {
  pools = {
    # example = {
    #   comment = "Example pool"
    # }
    backup = {
      comment = "backup pool"
    }
  }
}
