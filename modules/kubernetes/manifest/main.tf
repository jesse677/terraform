resource "kubernetes_manifest" "this" {
  for_each = {
    for manifest in var.manifests :
    "${manifest.kind}/${try(manifest.metadata.namespace, "_cluster")}/${manifest.metadata.name}" => manifest
  }

  manifest = each.value
}
