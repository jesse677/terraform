terraform {
    source = "../../../../modules/kubernetes/manifest"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

dependency "argocd_bootstrap" {
    config_path = "../argocd-bootstrap"

    mock_outputs = {
        applied = ["pending"]
    }
    mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

inputs = {
    manifests = yamldecode(templatefile("manifests.yaml.tpl", {
        alpaca_api_key    = base64encode(get_env("ALPACA_API_KEY")),
        alpaca_api_secret = base64encode(get_env("ALPACA_API_SECRET")),
    }))
}
