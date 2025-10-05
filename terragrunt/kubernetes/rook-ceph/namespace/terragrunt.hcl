terraform {
  source = "../../../../modules/kubernetes/namespace"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  name = "rook-ceph"
  labels = {
    "app.kubernetes.io/name" = "rook-ceph"
    "purpose"                = "storage"
  }
}