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
  name       = "grafana"
  namespace  = dependency.namespace.outputs.name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"

  values = [
    file("values.yaml")
  ]
}