terraform {
    source = "../../../modules/kubernetes/helm-release"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

inputs = {
    name             = "argocd"
    namespace        = "argocd"
    repository       = "https://argoproj.github.io/argo-helm"
    chart            = "argo-cd"
    chart_version    = "7.7.5"
    create_namespace = true
    timeout          = "50"
    cleanup_on_fail  = true

    values = [
        file("values.yml")
    ]
}