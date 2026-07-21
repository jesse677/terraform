include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/dns/records"
}

locals {
  data = read_terragrunt_config("records.hcl")
}

inputs = {
  records = local.data.locals.records
}
