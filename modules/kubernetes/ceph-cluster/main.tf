# CephCluster resource
resource "kubernetes_manifest" "ceph_cluster" {
  manifest = {
    apiVersion = "ceph.rook.io/v1"
    kind       = "CephCluster"
    metadata = {
      name      = var.cluster_name
      namespace = var.namespace
    }
    spec = {
      cephVersion = {
        image            = var.ceph_version_image
        allowUnsupported = var.allow_unsupported_version
      }
      
      dataDirHostPath = var.data_dir_host_path
      
      # Monitoring configuration
      monitoring = {
        enabled         = var.monitoring_enabled
        metricsDisabled = var.metrics_disabled
      }
      
      # Network configuration
      network = {
        hostNetwork = var.host_network
      }
      
      # Dashboard configuration
      dashboard = {
        enabled = var.dashboard_enabled
        ssl     = var.dashboard_ssl
      }
      
      # Crash collector
      crashCollector = {
        disable = var.crash_collector_disable
      }
      
      # Log collector
      logCollector = {
        enabled     = var.log_collector_enabled
        periodicity = var.log_collector_periodicity
        maxLogSize  = var.log_collector_max_log_size
      }
      
      # Clean up policy
      cleanupPolicy = {
        confirmation = var.cleanup_policy_confirmation
        sanitizeDisks = {
          method      = var.sanitize_disks_method
          dataSource  = var.sanitize_disks_data_source
          iteration   = var.sanitize_disks_iteration
        }
        allowUninstallWithVolumes = var.allow_uninstall_with_volumes
      }
      
      # Storage configuration
      storage = {
        useAllNodes   = var.use_all_nodes
        useAllDevices = var.use_all_devices
        
        # Conditional nodes configuration
        nodes = var.storage_nodes
        
        config = {
          osdsPerDevice   = var.osds_per_device
          encryptedDevice = var.encrypted_device
        }
      }
      
      # Mon configuration moved outside of placement to avoid provider issues
      mon = {
        count                 = var.mon_count
        allowMultiplePerNode = var.mon_allow_multiple_per_node
        volumeClaimTemplate = var.mon_volume_claim_template != null ? {
          spec = {
            storageClassName = var.mon_volume_claim_template.storage_class_name
            resources = {
              requests = {
                storage = var.mon_volume_claim_template.storage_size
              }
            }
          }
        } : null
      }
      
      # Placement only for tolerations
      placement = {
        all = {
          tolerations = [for toleration in var.tolerations : {
            effect   = toleration.effect
            key      = toleration.key
            operator = toleration.operator
          }]
        }
      }
      
      # Resource configuration
      resources = {
        mon = {
          limits = {
            cpu    = var.resource_limits.mon.cpu
            memory = var.resource_limits.mon.memory
          }
          requests = {
            cpu    = var.resource_requests.mon.cpu
            memory = var.resource_requests.mon.memory
          }
        }
        osd = {
          limits = {
            cpu    = var.resource_limits.osd.cpu
            memory = var.resource_limits.osd.memory
          }
          requests = {
            cpu    = var.resource_requests.osd.cpu
            memory = var.resource_requests.osd.memory
          }
        }
        mgr = {
          limits = {
            cpu    = var.resource_limits.mgr.cpu
            memory = var.resource_limits.mgr.memory
          }
          requests = {
            cpu    = var.resource_requests.mgr.cpu
            memory = var.resource_requests.mgr.memory
          }
        }
      }
      
      # Priority class names
      priorityClassNames = var.priority_class_names != null ? {
        mon = var.priority_class_names.mon
        osd = var.priority_class_names.osd 
        mgr = var.priority_class_names.mgr
      } : null
      
      # Disruption management
      disruptionManagement = {
        managePodBudgets                = var.disruption_management_enabled
        machineDisruptionBudgetNamespace = var.disruption_management_namespace != null ? var.disruption_management_namespace : "openshift-machine-api"
      }
    }
  }
  
  # Ignore changes to placement configuration after initial creation
  # to avoid provider inconsistency issues
  lifecycle {
    ignore_changes = [
      manifest["spec"]["placement"]
    ]
  }
}