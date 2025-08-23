# Create namespace for Rook operator
resource "kubernetes_namespace" "rook_namespace" {
  metadata {
    name = var.namespace
  }
}

# Deploy Rook operator via Helm
resource "helm_release" "rook_operator" {
  name       = var.release_name
  namespace  = kubernetes_namespace.rook_namespace.metadata[0].name
  repository = var.helm_repository
  chart      = "rook-ceph"
  version    = var.chart_version

  # Core configuration
  set {
    name  = "crds.enabled"
    value = var.enable_crds
  }

  set {
    name  = "enableDiscoveryDaemon"
    value = var.enable_discovery_daemon
  }

  set {
    name  = "logLevel"
    value = var.log_level
  }

  set {
    name  = "csi.enableRbdDriver"
    value = var.enable_rbd_driver
  }

  set {
    name  = "csi.enableCephfsDriver"
    value = var.enable_cephfs_driver
  }

  # Resource limits
  set {
    name  = "resources.limits.cpu"
    value = var.resource_limits_cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.resource_limits_memory
  }

  # Dynamic tolerations for discovery daemon
  dynamic "set" {
    for_each = { for idx, toleration in var.tolerations : idx => toleration }
    content {
      name  = "discover.tolerations[${set.key}].effect"
      value = set.value.effect
    }
  }

  dynamic "set" {
    for_each = { for idx, toleration in var.tolerations : idx => toleration }
    content {
      name  = "discover.tolerations[${set.key}].key"
      value = set.value.key
    }
  }

  dynamic "set" {
    for_each = { for idx, toleration in var.tolerations : idx => toleration }
    content {
      name  = "discover.tolerations[${set.key}].operator"
      value = set.value.operator
    }
  }
  

  # Additional Helm values for advanced configuration
  values = var.helm_values != null ? [var.helm_values] : []

  depends_on = [kubernetes_namespace.rook_namespace]
}