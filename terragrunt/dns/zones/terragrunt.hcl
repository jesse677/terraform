include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/dns/zones"
}

locals {
  data = read_terragrunt_config("zones.hcl")
}

inputs = {
  zones = local.data.locals.zones
}
