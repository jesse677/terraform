locals {
  # GCP Configuration
  gcp_project_id = "vidiforge-production"
  gcp_region     = "us-central1"
  gcp_zone       = "us-central1-a"
  
  # Network Configuration
  vpc_network    = "vidiforge-vpc"
  subnet_name    = "vidiforge-subnet"
  subnet_cidr    = "10.0.0.0/16"
  
  # Common Resource Settings
  environment = get_env("ENVIRONMENT", "dev")
  
  # Storage Configuration
  storage_bucket_name = "vidiforge-${local.environment}-storage"
  storage_location   = "US"
  storage_class      = "STANDARD"
  
  # Database Configuration
  db_tier           = "db-g1-small"
  db_disk_size      = 20
  db_disk_type      = "PD_SSD"
  db_version        = "POSTGRES_15"
  db_backup_enabled = true
  
  # Application Configuration
  app_image_tag = get_env("APP_IMAGE_TAG", "latest")
  app_min_instances = local.environment == "prod" ? 2 : 0
  app_max_instances = local.environment == "prod" ? 10 : 5
  app_cpu_limit     = "1000m"
  app_memory_limit  = "1Gi"
  
  # Job Queue Configuration
  pubsub_topic_name        = "vidiforge-${local.environment}-jobs"
  pubsub_subscription_name = "vidiforge-${local.environment}-worker"
  
  # Common Labels
  common_labels = {
    project     = "vidiforge"
    environment = local.environment
    managed_by  = "terragrunt"
    team        = "platform"
  }
  
  # Common Environment Variables (non-sensitive)
  common_env_vars = {
    ENVIRONMENT         = local.environment
    GCP_PROJECT_ID     = local.gcp_project_id
    GCP_REGION         = local.gcp_region
    STORAGE_BUCKET     = local.storage_bucket_name
    PUBSUB_TOPIC       = local.pubsub_topic_name
    PUBSUB_SUBSCRIPTION = local.pubsub_subscription_name
  }
  
  # CORS settings for GCS bucket
  cors_rules = [
    {
      origin          = ["https://vidiforge.app", "https://*.vidiforge.app"]
      method          = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
      response_header = ["Content-Type", "Authorization", "x-goog-resumable"]
      max_age_seconds = 3600
    }
  ]
  
  # Lifecycle rules for GCS bucket
  lifecycle_rules = [
    {
      age           = 30
      action_type   = "SetStorageClass"
      storage_class = "NEARLINE"
    },
    {
      age         = 90
      action_type = "Delete"
    }
  ]
  
  # Database users
  db_users = {
    "vidiforge-app" = {
      password = null  # Will be auto-generated
      type     = "BUILT_IN"
    }
  }
  
  # Pub/Sub subscription configuration
  subscriptions = {
    "video-processing" = {
      ack_deadline_seconds = 600  # 10 minutes for video processing
      filter              = "attributes.job_type=\"video_processing\""
    }
    "clip-generation" = {
      ack_deadline_seconds = 300  # 5 minutes for clip generation  
      filter              = "attributes.job_type=\"clip_generation\""
    }
    "notification" = {
      ack_deadline_seconds = 30   # 30 seconds for notifications
      filter              = "attributes.job_type=\"notification\""
    }
  }
}

remote_state {
  backend = "gcs"
  config = {
    bucket = "vidiforge-terraform-state"
    prefix = "${path_relative_to_include()}/terraform.tfstate"
  }
}