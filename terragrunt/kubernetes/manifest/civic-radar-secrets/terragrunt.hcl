terraform {
    source = "../../../../modules/kubernetes/manifest"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

# Apply kubernetes/helm/civic-radar-postgres first - it creates the
# "civic-radar" namespace this Secret targets.
inputs = {
    manifests = yamldecode(templatefile("manifests.yaml.tpl", {
        session_secret = base64encode(get_env("CIVIC_RADAR_SESSION_SECRET"))
        db_password    = base64encode(get_env("CIVIC_RADAR_DB_PASSWORD"))
    }))
}
