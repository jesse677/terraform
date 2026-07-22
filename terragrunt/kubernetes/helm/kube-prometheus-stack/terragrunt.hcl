terraform {
    source = "../../../../modules/kubernetes/helm-release"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

inputs = {
    name             = "kube-prometheus-stack"
    namespace        = "kube-prometheus-stack"
    repository       = "https://prometheus-community.github.io/helm-charts"
    chart            = "kube-prometheus-stack"
    chart_version    = "87.19.0"
    create_namespace = true
    timeout          = "300"
    cleanup_on_fail  = true

    values = [
        templatefile("values.yml.tpl", {
            pve_host = get_env("PVE_HOST")
        })
    ]
}
