include "root" {
  path = find_in_parent_folders("elk-root.hcl")
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("elk-root.hcl"))
}

terraform {
  source = "."
}

inputs = {
  namespace = local.root.locals.elk_namespace
  elasticsearch_config = local.root.locals.elasticsearch
  common_labels = local.root.locals.common_labels
}