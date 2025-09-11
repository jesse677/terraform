terraform {
  required_version = ">= 1.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}

resource "random_password" "k3s_token" {
  count   = var.generate_token ? 1 : 0
  length  = 32
  special = false
}

locals {
  k3s_token = var.generate_token ? random_password.k3s_token[0].result : var.k3s_token
  
  first_server = values(var.server_nodes)[0]
  
  server_init_args = concat([
    "--cluster-init",
    "--token=${local.k3s_token}",
    "--cluster-cidr=${var.cluster_cidr}",
    "--service-cidr=${var.service_cidr}",
    "--cluster-dns=${var.cluster_dns}",
    "--flannel-backend=${var.flannel_backend}",
    "--node-ip=${local.first_server.internal_ip}",
    "--node-external-ip=${local.first_server.external_ip}",
    "--tls-san=${local.first_server.external_ip}",
    "--tls-san=${local.first_server.internal_ip}",
  ], [
    for component in var.disable_components : "--disable=${component}"
  ], var.server_args)
  
  server_join_args = concat([
    "--server=https://${local.first_server.internal_ip}:6443",
    "--token=${local.k3s_token}",
  ], var.server_args)
  
  agent_join_args = concat([
    "--server=https://${local.first_server.internal_ip}:6443",
    "--token=${local.k3s_token}",
  ], var.agent_args)
}

module "first_server" {
  source = "../server"
  
  for_each = { for k, v in var.server_nodes : k => v if k == keys(var.server_nodes)[0] }
  
  node_name    = each.key
  host         = each.value.host
  internal_ip  = each.value.internal_ip
  external_ip  = each.value.external_ip
  user         = each.value.user
  private_key  = each.value.private_key
  labels       = each.value.labels
  taints       = each.value.taints
  
  k3s_version  = var.k3s_version
  k3s_args     = local.server_init_args
  is_first     = true
}

module "additional_servers" {
  source = "../server"
  
  for_each = { for k, v in var.server_nodes : k => v if k != keys(var.server_nodes)[0] }
  
  node_name    = each.key
  host         = each.value.host
  internal_ip  = each.value.internal_ip
  external_ip  = each.value.external_ip
  user         = each.value.user
  private_key  = each.value.private_key
  labels       = each.value.labels
  taints       = each.value.taints
  
  k3s_version  = var.k3s_version
  k3s_args     = local.server_join_args
  is_first     = false
  
  depends_on = [module.first_server]
}

module "agents" {
  source = "../agent"
  
  for_each = var.agent_nodes
  
  node_name    = each.key
  host         = each.value.host
  internal_ip  = each.value.internal_ip
  external_ip  = each.value.external_ip
  user         = each.value.user
  private_key  = each.value.private_key
  labels       = each.value.labels
  taints       = each.value.taints
  
  k3s_version  = var.k3s_version
  k3s_args     = local.agent_join_args
  
  depends_on = [module.first_server]
}

resource "null_resource" "kubeconfig" {
  depends_on = [module.first_server]
  
  provisioner "local-exec" {
    command = <<-EOT
      ssh -o StrictHostKeyChecking=no -i ${local.first_server.private_key} \
        ${local.first_server.user}@${local.first_server.external_ip} \
        'sudo cat /etc/rancher/k3s/k3s.yaml' | \
        sed "s/127.0.0.1/${local.first_server.external_ip}/g" > ${path.module}/kubeconfig.yaml
    EOT
  }
  
  triggers = {
    server = local.first_server.host
  }
}