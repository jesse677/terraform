include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "app_defaults" {
  path = find_in_parent_folders("_envcommon/app-defaults.hcl")
}

terraform {
  source = "../../../../modules/google/gcs"
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

inputs = {
  bucket_name                 = local.root.locals.storage_bucket_name
  location                   = local.root.locals.storage_location
  storage_class              = local.root.locals.storage_class
  force_destroy              = local.root.locals.environment != "prod"
  uniform_bucket_level_access = true
  versioning_enabled         = local.root.locals.environment == "prod"
  
  # CORS configuration for web uploads
  cors_rules = local.root.locals.cors_rules
  
  # Lifecycle management
  lifecycle_rules = local.root.locals.lifecycle_rules
  
  # IAM bindings
  iam_bindings = {
    "roles/storage.objectViewer" = [
      "serviceAccount:vidiforge-api@${local.root.locals.gcp_project_id}.iam.gserviceaccount.com"
    ]
    "roles/storage.objectCreator" = [
      "serviceAccount:vidiforge-api@${local.root.locals.gcp_project_id}.iam.gserviceaccount.com"
    ]
    "roles/storage.legacyBucketWriter" = [
      "serviceAccount:vidiforge-api@${local.root.locals.gcp_project_id}.iam.gserviceaccount.com"
    ]
  }
  
  # Pub/Sub notification for processing triggers
  notification_config = {
    topic             = "projects/${local.root.locals.gcp_project_id}/topics/storage-notifications"
    payload_format    = "JSON_API_V1"
    event_types       = ["OBJECT_FINALIZE", "OBJECT_DELETE"]
    custom_attributes = {
      environment = local.root.locals.environment
      bucket_type = "storage"
    }
  }
}