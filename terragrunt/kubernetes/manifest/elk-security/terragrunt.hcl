terraform {
    source = "../../../../modules/kubernetes/manifest"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

inputs = {
    manifests = yamldecode(templatefile("manifests.yaml.tpl", {
        elastic_password           = base64encode(get_env("ELK_ELASTIC_PASSWORD"))
        kibana_system_password     = base64encode(get_env("ELK_KIBANA_SYSTEM_PASSWORD"))
        logstash_internal_password = base64encode(get_env("ELK_LOGSTASH_INTERNAL_PASSWORD"))
        kibana_encryption_key      = base64encode(get_env("ELK_KIBANA_ENCRYPTION_KEY"))
        elasticsearch_certs_p12    = filebase64("certs/elastic-certificates.p12")
    }))
}
