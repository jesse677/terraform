include "root" {
  path = find_in_parent_folders("elk-root.hcl")
}

terraform {
  source = "."
}

dependency "elasticsearch" {
  config_path = "../elasticsearch"
}

inputs = {
  namespace = local.elk_namespace
  logstash_config = local.logstash
  common_labels = local.common_labels
  elasticsearch_hosts = dependency.elasticsearch.outputs.elasticsearch_service
}