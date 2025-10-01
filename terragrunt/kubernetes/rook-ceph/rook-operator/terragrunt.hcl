terraform {
  source = "../../../../modules/kubernetes/helm-release"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "namespace" {
  config_path = "../namespace"
}

inputs = {
  name       = "rook-ceph"
  namespace  = dependency.namespace.outputs.name
  repository = "https://charts.rook.io/release"
  chart      = "rook-ceph"

  values = [
    file("values.yaml")
  ]
}