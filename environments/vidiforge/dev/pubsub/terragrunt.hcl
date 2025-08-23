include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "app_defaults" {
  path = find_in_parent_folders("_envcommon/app-defaults.hcl")
}

terraform {
  source = "../../../../modules/google/pubsub"
}

dependencies {
  paths = ["../storage"]
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

inputs = {
  topic_name                  = local.root.locals.pubsub_topic_name
  project_id                  = local.root.locals.gcp_project_id
  message_retention_duration  = "604800s"  # 7 days
  
  # Topic IAM bindings
  topic_iam_bindings = {
    "roles/pubsub.publisher" = [
      "serviceAccount:vidiforge-api@${local.root.locals.gcp_project_id}.iam.gserviceaccount.com",
      "serviceAccount:vidiforge-worker@${local.root.locals.gcp_project_id}.iam.gserviceaccount.com"
    ]
  }
  
  # Subscriptions for different job types
  subscriptions = merge(local.root.locals.subscriptions, {
    # Video processing subscription (long-running jobs)
    "video-processing" = {
      ack_deadline_seconds       = 600  # 10 minutes
      message_retention_duration = "604800s"  # 7 days
      filter                    = "attributes.job_type=\"video_processing\""
      enable_message_ordering   = true
      
      # Retry policy for failed jobs
      retry_policy = {
        minimum_backoff = "10s"
        maximum_backoff = "600s"
      }
      
      # Dead letter for completely failed jobs
      dead_letter_topic     = "projects/${local.root.locals.gcp_project_id}/topics/failed-jobs"
      max_delivery_attempts = 5
      
      iam_bindings = {
        "roles/pubsub.subscriber" = [
          "serviceAccount:vidiforge-worker@${local.root.locals.gcp_project_id}.iam.gserviceaccount.com"
        ]
      }
    }
    
    # Clip generation subscription (medium-running jobs)
    "clip-generation" = {
      ack_deadline_seconds       = 300  # 5 minutes
      message_retention_duration = "604800s"  # 7 days
      filter                    = "attributes.job_type=\"clip_generation\""
      enable_message_ordering   = true
      
      retry_policy = {
        minimum_backoff = "5s"
        maximum_backoff = "300s"
      }
      
      dead_letter_topic     = "projects/${local.root.locals.gcp_project_id}/topics/failed-jobs"
      max_delivery_attempts = 3
      
      iam_bindings = {
        "roles/pubsub.subscriber" = [
          "serviceAccount:vidiforge-worker@${local.root.locals.gcp_project_id}.iam.gserviceaccount.com"
        ]
      }
    }
    
    # Notification subscription (quick jobs)
    "notification" = {
      ack_deadline_seconds       = 30   # 30 seconds
      message_retention_duration = "86400s"  # 1 day
      filter                    = "attributes.job_type=\"notification\""
      
      retry_policy = {
        minimum_backoff = "1s"
        maximum_backoff = "30s"
      }
      
      max_delivery_attempts = 3
      
      iam_bindings = {
        "roles/pubsub.subscriber" = [
          "serviceAccount:vidiforge-api@${local.root.locals.gcp_project_id}.iam.gserviceaccount.com"
        ]
      }
    }
    
    # Webhook notifications (push-based)
    "webhooks" = {
      ack_deadline_seconds = 30
      filter              = "attributes.job_type=\"webhook\""
      
      push_endpoint = "https://vidiforge-${local.root.locals.environment}-api-${random_id.webhook_secret.hex}.a.run.app/webhooks/pubsub"
      push_attributes = {
        x-goog-version = "v1"
      }
      
      # OIDC authentication for the push endpoint
      oidc_service_account_email = "vidiforge-api@${local.root.locals.gcp_project_id}.iam.gserviceaccount.com"
      oidc_audience             = "vidiforge-${local.root.locals.environment}-api"
    }
  })
  
  # Create snapshots for important subscriptions in production
  snapshots = local.root.locals.environment == "prod" ? {
    "video-processing-backup" = {
      subscription = "video-processing"
    }
    "clip-generation-backup" = {
      subscription = "clip-generation" 
    }
  } : {}
}

# Generate a random ID for webhook security
resource "random_id" "webhook_secret" {
  byte_length = 8
}