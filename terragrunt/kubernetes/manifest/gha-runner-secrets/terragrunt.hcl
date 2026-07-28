terraform {
    source = "../../../../modules/kubernetes/manifest"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

# Apply kubernetes/manifest/gha-runner-namespace first - it creates the
# "arc-runners" namespace this Secret targets.
#
# GitHub App auth (chosen over a PAT: scoped permissions, higher API rate
# limits, no user token to rotate). To create it:
#   1. github.com/settings/apps -> New GitHub App (or the org's Developer
#      settings, if the runner should live at the org level later).
#   2. Repository permissions: Actions (Read & write), Administration
#      (Read & write).
#   3. Install the App on the target repo.
#   4. Generate a private key (downloads a .pem) - save it as
#      private-key.pem in this directory (gitignored, like elk-security's
#      certs/).
# Then set in a gitignored .env in this directory:
#   GHA_APP_ID              - App ID, from the App's "General" settings page
#   GHA_APP_INSTALLATION_ID - Installation ID, from the URL after installing
#                              the App on the repo (.../installations/<id>)
dependency "gha_runner_namespace" {
    config_path = "../gha-runner-namespace"

    mock_outputs = {
        applied = []
    }
    mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

inputs = {
    manifests = yamldecode(templatefile("manifests.yaml.tpl", {
        github_app_id              = base64encode(get_env("GHA_APP_ID"))
        github_app_installation_id = base64encode(get_env("GHA_APP_INSTALLATION_ID"))
        github_app_private_key     = filebase64("private-key.pem")
    }))
}
