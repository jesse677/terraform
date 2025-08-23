include "root" {
  path = find_in_parent_folders("elk-root.hcl")
}

terraform {
  source = "."
}

dependency "logstash" {
  config_path = "../logstash"
}

inputs = {
  namespace = local.elk_namespace
  filebeat_config = local.filebeat
  common_labels = local.common_labels
  logstash_hosts = dependency.logstash.outputs.logstash_service
}