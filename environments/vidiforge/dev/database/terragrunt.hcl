include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "app_defaults" {
  path = find_in_parent_folders("_envcommon/app-defaults.hcl")
}

terraform {
  source = "../../../../modules/google/cloud-sql"
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

inputs = {
  instance_name       = "vidiforge-${local.root.locals.environment}-db"
  project_id          = local.root.locals.gcp_project_id
  region              = local.root.locals.gcp_region
  database_version    = local.root.locals.db_version
  tier                = local.root.locals.db_tier
  
  # Disk configuration
  disk_type             = local.root.locals.db_disk_type
  disk_size             = local.root.locals.db_disk_size
  disk_autoresize       = true
  disk_autoresize_limit = local.root.locals.environment == "prod" ? 500 : 100
  
  # Availability
  availability_type = local.root.locals.environment == "prod" ? "REGIONAL" : "ZONAL"
  
  # Security
  deletion_protection = local.root.locals.environment == "prod"
  require_ssl        = true
  ssl_mode          = "ENCRYPTED_ONLY"
  
  # Networking - private IP only for production
  ipv4_enabled    = local.root.locals.environment != "prod"
  private_network = local.root.locals.environment == "prod" ? "projects/${local.root.locals.gcp_project_id}/global/networks/${local.root.locals.vpc_network}" : null
  
  # Backup configuration
  backup_enabled                 = local.root.locals.db_backup_enabled
  backup_start_time             = "02:00"
  point_in_time_recovery_enabled = local.root.locals.environment == "prod"
  transaction_log_retention_days = local.root.locals.environment == "prod" ? 7 : 3
  backup_retained_backups       = local.root.locals.environment == "prod" ? 30 : 7
  
  # Maintenance window
  maintenance_window = {
    day          = 7  # Sunday
    hour         = 3  # 3 AM
    update_track = "stable"
  }
  
  # Database flags for performance
  database_flags = {
    "shared_preload_libraries" = "pg_stat_statements"
    "max_connections"         = "200"
    "shared_buffers"          = "256MB"
    "effective_cache_size"    = "1GB"
    "work_mem"               = "4MB"
  }
  
  # Monitoring
  query_insights_enabled  = true
  record_application_tags = true
  record_client_address   = false
  
  # Create databases
  databases = ["vidiforge", "vidiforge_test"]
  
  # Create application user
  users = local.root.locals.db_users
}