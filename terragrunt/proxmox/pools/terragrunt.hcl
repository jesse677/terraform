include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/proxmox/pool"
}

locals {
  data = read_terragrunt_config("pools.hcl")
}

inputs = {
  pools = local.data.locals.pools
}
