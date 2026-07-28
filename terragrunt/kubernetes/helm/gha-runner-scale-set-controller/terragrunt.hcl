terraform {
    source = "../../../../modules/kubernetes/helm-release"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

# Cluster-singleton controller. Installs the AutoscalingRunnerSet /
# AutoscalingListener CRDs and the manager that reconciles them - only one
# of these should exist per cluster, no matter how many runner scale sets
# (helm/gha-runner-scale-set-*) point at it.
inputs = {
    name             = "arc"
    namespace        = "arc-systems"
    repository       = "oci://ghcr.io/actions/actions-runner-controller-charts"
    chart            = "gha-runner-scale-set-controller"
    chart_version    = "0.14.2"
    create_namespace = true
    timeout          = "300"
    cleanup_on_fail  = true
}
