terraform {
    source = "../../../../modules/kubernetes/manifest"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

dependency "metallb" {
    config_path = "../../helm/metallb"

    mock_outputs = {
        status = "pending"
    }
    mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

inputs = {
    manifests = yamldecode(file("manifests.yaml"))
}
