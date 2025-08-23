
resource "kubernetes_manifest" "argocd_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name        = var.name
      namespace   = var.namespace
      finalizers  = var.finalizers
      labels      = var.labels
      annotations = var.annotations
    }
    spec = {
      project = var.project
      source = {
        repoURL        = var.repo_url
        targetRevision = var.target_revision
        path           = var.path
      }
      destination = {
        server    = var.destination_server
        namespace = var.destination_namespace
      }
      syncPolicy = {
        automated = {
          prune    = var.automated_prune
          selfHeal = var.automated_self_heal
        }
        syncOptions = var.sync_options
      }
    }
  }
}