remote_state {
  backend = "local"
  config = {
    path = "/mnt/c/kubernetes/terraform-state/${path_relative_to_include()}/terraform.tfstate"
  }
}

terraform {
  extra_arguments "common_vars" {
    commands = ["plan", "apply", "destroy"]
  }
}

# Generate backend configuration
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "local" {}
}
EOF
}

# Generate provider configuration
generate "provider_config" {
  path      = "provider_config.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}
EOF
}