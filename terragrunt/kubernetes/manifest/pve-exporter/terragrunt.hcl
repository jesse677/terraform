terraform {
    source = "../../../../modules/kubernetes/manifest"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

dependency "kube_prometheus_stack" {
    config_path = "../../helm/kube-prometheus-stack"

    mock_outputs = {
        status = "pending"
    }
    mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

inputs = {
    manifests = yamldecode(templatefile("manifests.yaml.tpl", {
        pve_token_value = get_env("PVE_EXPORTER_TOKEN_VALUE")
    }))
}
