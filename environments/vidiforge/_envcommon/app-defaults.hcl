locals {
  root = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

inputs = {
  # Pass through root configuration
  project_id = local.root.locals.gcp_project_id
  region     = local.root.locals.gcp_region
  zone       = local.root.locals.gcp_zone
  
  # Network configuration
  vpc_network  = local.root.locals.vpc_network
  subnet_name  = local.root.locals.subnet_name
  subnet_cidr  = local.root.locals.subnet_cidr
  
  # Common labels
  labels = local.root.locals.common_labels
  
  # Environment
  environment = local.root.locals.environment
  
  # Storage
  storage_bucket_name = local.root.locals.storage_bucket_name
  storage_location   = local.root.locals.storage_location
  storage_class      = local.root.locals.storage_class
  cors_rules         = local.root.locals.cors_rules
  lifecycle_rules    = local.root.locals.lifecycle_rules
  
  # Database
  db_tier           = local.root.locals.db_tier
  db_disk_size      = local.root.locals.db_disk_size
  db_disk_type      = local.root.locals.db_disk_type
  db_version        = local.root.locals.db_version
  db_backup_enabled = local.root.locals.db_backup_enabled
  db_users          = local.root.locals.db_users
  
  # Application
  app_image_tag     = local.root.locals.app_image_tag
  app_min_instances = local.root.locals.app_min_instances
  app_max_instances = local.root.locals.app_max_instances
  app_cpu_limit     = local.root.locals.app_cpu_limit
  app_memory_limit  = local.root.locals.app_memory_limit
  common_env_vars   = local.root.locals.common_env_vars
  
  # Pub/Sub
  pubsub_topic_name   = local.root.locals.pubsub_topic_name
  subscriptions       = local.root.locals.subscriptions
}