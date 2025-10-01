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
  name       = "prometheus"
  namespace  = dependency.namespace.outputs.name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"

  values = [
    file("values.yaml")
  ]
}