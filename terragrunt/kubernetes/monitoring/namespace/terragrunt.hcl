terraform {
  source = "../../../../modules/kubernetes/namespace"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  name = "monitoring"
  labels = {
    "app.kubernetes.io/name" = "monitoring"
    "purpose"                = "monitoring"
  }
}