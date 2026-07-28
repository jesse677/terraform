terraform {
    source = "../../../../modules/kubernetes/manifest"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

# Separate from gha-runner-secrets so the namespace reliably exists before
# the Secret that targets it is applied - bundling Namespace + Secret in one
# kubernetes_manifest for_each has no guaranteed ordering.
inputs = {
    manifests = yamldecode(file("manifests.yaml"))
}
