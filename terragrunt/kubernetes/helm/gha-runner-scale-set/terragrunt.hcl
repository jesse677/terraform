terraform {
    source = "../../../../modules/kubernetes/helm-release"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

# Needs the controller's CRDs (AutoscalingRunnerSet) installed first.
dependency "controller" {
    config_path = "../gha-runner-scale-set-controller"

    mock_outputs = {
        status = "pending"
    }
    mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

# Needs the "arc-runners" namespace and gha-runner-secrets Secret to exist
# first (githubConfigSecret in values.yml references it by name).
dependency "gha_runner_secrets" {
    config_path = "../../manifest/gha-runner-secrets"

    mock_outputs = {
        applied = []
    }
    mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

inputs = {
    name             = "gha-runner"
    namespace        = "arc-runners"
    repository       = "oci://ghcr.io/actions/actions-runner-controller-charts"
    chart            = "gha-runner-scale-set"
    chart_version    = "0.14.2"
    create_namespace = false
    timeout          = "300"
    cleanup_on_fail  = true

    values = [
        file("values.yml")
    ]
}
