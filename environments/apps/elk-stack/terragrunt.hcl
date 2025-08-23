terraform {
  source = "."
}

locals {
  # ELK Stack Configuration - Define all config here
  elk_namespace = "elk-stack"
  
  # Common labels
  common_labels = {
    "app.kubernetes.io/part-of" = "elk-stack"
    "environment" = "production"
    "managed-by" = "terragrunt"
  }
}

inputs = {
  namespace = local.elk_namespace
  common_labels = local.common_labels
}