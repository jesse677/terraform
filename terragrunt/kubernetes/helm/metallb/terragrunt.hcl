terraform {
    source = "../../../../modules/kubernetes/helm-release"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

inputs = {
    name             = "metallb"
    namespace        = "metallb-system"
    repository       = "https://metallb.github.io/metallb"
    chart            = "metallb"
    chart_version    = "0.16.1"
    create_namespace = true
    timeout          = "50"
    cleanup_on_fail  = true
}
