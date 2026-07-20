terraform {
    source = "../../../../modules/kubernetes/helm-release"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

inputs = {
    name             = "grafana"
    namespace        = "grafana"
    repository       = "https://grafana.github.io/helm-charts"
    chart            = "grafana"
    chart_version    = "10.5.15"
    create_namespace = true
    timeout          = "50"
    cleanup_on_fail  = true

    values = [
        file("values.yml")
    ]
}
