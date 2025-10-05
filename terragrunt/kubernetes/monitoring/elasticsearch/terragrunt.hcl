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
  name       = "elasticsearch"
  namespace  = dependency.namespace.outputs.name
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"

  values = [
    file("values.yaml")
  ]
}