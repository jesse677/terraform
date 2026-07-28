terraform {
    source = "../../../../modules/kubernetes/manifest"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

# The tina-paper namespace is created by ArgoCD (CreateNamespace=true on the
# python-apps ApplicationSet) once the argocd repo changes are synced - apply
# this module after that sync has happened, not before. This dependency just
# ensures ArgoCD itself is up and bootstrapped.
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
