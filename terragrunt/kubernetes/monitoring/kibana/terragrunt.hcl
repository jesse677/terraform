terraform {
  source = "../../../../modules/kubernetes/helm-release"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "namespace" {
  config_path = "../namespace"
}

dependency "elasticsearch" {
  config_path = "../elasticsearch"
}

inputs = {
  name       = "kibana"
  namespace  = dependency.namespace.outputs.name
  repository = "https://helm.elastic.co"
  chart      = "kibana"

  values = [
    file("values.yaml")
  ]
}