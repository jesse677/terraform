locals {
  k3s_root = read_terragrunt_config(find_in_parent_folders("k3s-root.hcl"))
}

inputs = {
  k3s_server_ip = local.k3s_root.locals.k3s_server_ip
}