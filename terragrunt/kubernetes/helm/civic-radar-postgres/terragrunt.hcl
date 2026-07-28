terraform {
    source = "../../../../modules/kubernetes/helm-release"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

# Reads CIVIC_RADAR_DB_PASSWORD from the same .env sourced for
# kubernetes/manifest/civic-radar-secrets - Postgres and the app's Secret
# need to agree on this password. Apply this module first (create_namespace
# creates the "civic-radar" namespace that the secrets module targets next).
inputs = {
    name             = "civic-radar-postgres"
    namespace        = "civic-radar"
    #repository       = "https://charts.bitnami.com/bitnami"
    repository       = "oci://registry-1.docker.io/bitnamicharts"
    chart            = "postgresql"
    chart_version    = "18.8.1"
    create_namespace = true
    timeout          = "300"
    cleanup_on_fail  = true

    values = [
        file("values.yml")
    ]

    set_sensitive = [
        {
            name  = "auth.password"
            value = get_env("CIVIC_RADAR_DB_PASSWORD")
        }
    ]
}
