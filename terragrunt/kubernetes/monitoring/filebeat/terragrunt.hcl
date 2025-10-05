terraform {
  source = "../../../../modules/kubernetes/helm-release"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "namespace" {
  config_path = "../namespace"
}

dependency "logstash" {
  config_path = "../logstash"
}

inputs = {
  name       = "filebeat"
  namespace  = dependency.namespace.outputs.name
  repository = "https://helm.elastic.co"
  chart      = "filebeat"

  values = [
    file("values.yaml")
  ]
}