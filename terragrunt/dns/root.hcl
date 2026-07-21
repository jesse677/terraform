remote_state {
  backend = "local"
  config = {
    path = "/mnt/c/dns/terraform-state/${path_relative_to_include()}/terraform.tfstate"
  }
}

# Technitium provider auth, shared by every dns/* module. Set these in the
# environment before running terragrunt (same pattern as VM_PASSWORD for the
# proxmox VMs) - they're merged into inputs for zones/ and records/ below.
inputs = {
  technitium_url   = get_env("TECHNITIUM_API_URL")
  technitium_token = get_env("TECHNITIUM_API_TOKEN")
}
