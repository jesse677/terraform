terraform {
  source = "../../../../modules/kubernetes/helm-release"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "namespace" {
  config_path = "../namespace"
}

dependency "rook_operator" {
  config_path = "../rook-operator"
}

inputs = {
  name       = "rook-ceph-cluster"
  namespace  = dependency.namespace.outputs.name
  repository = "https://charts.rook.io/release"
  chart      = "rook-ceph-cluster"

  values = [
    file("values.yaml")
  ]
}