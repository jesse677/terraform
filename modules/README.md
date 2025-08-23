# Terraform Modules

This repository contains Terraform modules for managing Proxmox VE infrastructure and Kubernetes resources. The modules are designed to be used with Terragrunt for infrastructure management.

## Module Structure

```
terraform-modules/
└── modules/
    ├── proxmox/
    │   └── vm/
    │       ├── main.tf          # Main VM resource definitions
    │       ├── variables.tf     # Input variables
    │       ├── outputs.tf       # Output values
    │       ├── providers.tf     # Provider requirements
    │       └── backend.tf       # Backend configuration
    └── kubernetes/
        ├── ceph-cluster/
        │   ├── main.tf          # Ceph cluster configuration
        │   ├── variables.tf     # Input variables
        │   ├── outputs.tf       # Output values
        │   ├── providers.tf     # Provider requirements
        │   └── backend.tf       # Backend configuration
        └── rook-operator/
            ├── main.tf          # Rook operator configuration
            ├── variables.tf     # Input variables
            ├── outputs.tf       # Output values
            ├── providers.tf     # Provider requirements
            └── backend.tf       # Backend configuration
```

## Features

### Proxmox Modules
- **VM Creation**: Full Proxmox VM lifecycle management
- **Cloud-init Support**: Automated VM initialization with user data
- **Network Configuration**: Multiple network interfaces with VLAN support
- **Storage Management**: Flexible disk configuration with multiple datastores
- **SSH Key Management**: Automated SSH key deployment
- **Backward Compatibility**: Support for legacy variable names

### Kubernetes Modules
- **Rook Operator**: Deploy and manage Rook operator for Ceph storage
- **Ceph Cluster**: Create and configure Ceph storage clusters
- **Storage Integration**: Seamless integration with K3s clusters

## Usage with Terragrunt

This module is designed to be used with Terragrunt. Here's how it's typically consumed:

### Terragrunt Configuration Example

```hcl
terraform {
  source = "../../../terraform-modules/modules/proxmox/vm"
}

inputs = {
  name      = "my-vm"
  node_name = "proxmox-node-01"
  cores     = 4
  memory    = 8192
  
  disks = [
    {
      datastore_id = "local-lvm"
      file_id      = "local:iso/ubuntu-22.04-server-cloudimg-amd64.img"
      interface    = "scsi0"
      size         = 100
      file_format  = "raw"
    }
  ]
  
  network_devices = [
    {
      bridge = "vmbr0"
    }
  ]
  
  ip_configs = [
    {
      address = "192.168.1.100/24"
      gateway = "192.168.1.1"
    }
  ]
  
  username            = "ubuntu"
  ssh_public_key_file = "~/.ssh/id_rsa.pub"
  datastore_id        = "local"
  
  user_data = <<-EOT
    #cloud-config
    hostname: my-vm
    package_update: true
    users:
      - name: ubuntu
        groups: sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        ssh_authorized_keys:
          - ${file("~/.ssh/id_rsa.pub")}
  EOT
}
```

## Environment Variables

The module requires Proxmox authentication via environment variables:

```bash
# Required: Proxmox endpoint and credentials
export PROXMOX_VE_ENDPOINT="https://your-proxmox-server:8006/"
export PROXMOX_VE_USERNAME="your-username@pam"
export PROXMOX_VE_PASSWORD="your-password"

# Alternative: Use API token authentication
export PROXMOX_VE_API_TOKEN="your-api-token-id=your-secret"

# Optional: Skip TLS verification (not recommended for production)
export PROXMOX_VE_INSECURE=true
```

## Input Variables

### Required Variables

| Variable | Type | Description |
|----------|------|-------------|
| `name` | `string` | Name of the VM in Proxmox |
| `node_name` | `string` | Proxmox node to deploy the VM on |

### Optional Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `cores` | `number` | `2` | Number of CPU cores |
| `memory` | `number` | `4096` | Memory in MB |
| `username` | `string` | `"ubuntu"` | Default username for the VM |
| `password` | `string` | `null` | Password for the user account |
| `os_type` | `string` | `"l26"` | Operating system type |
| `datastore_id` | `string` | `"local"` | Datastore for cloud-init files |

### Network Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `network_devices` | `list(object)` | `[]` | Network interface configuration |
| `ip_configs` | `list(object)` | `[]` | IP address configuration |

### Storage Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `disks` | `list(object)` | `[]` | Disk configuration |

### SSH Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `ssh_keys` | `list(string)` | `[]` | List of SSH public keys |
| `ssh_public_key_file` | `string` | `null` | Path to SSH public key file |

### Cloud-init Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `user_data` | `string` | `null` | Cloud-init user data YAML |
| `vendor_data` | `string` | `null` | Cloud-init vendor data YAML |
| `network_data` | `string` | `null` | Cloud-init network data YAML |
| `user_data_file_id` | `string` | `null` | External cloud-init user data file ID |

### Backward Compatibility

| Variable | Type | Description |
|----------|------|-------------|
| `node` | `string` | Deprecated, use `node_name` |
| `cloud_init_user_data` | `string` | Deprecated, use `user_data` |
| `cloud_init_datastore` | `string` | Deprecated, use `datastore_id` |

## Output Values

| Output | Description |
|--------|-------------|
| `vm_id` | The ID of the created VM |
| `vm_name` | The name of the created VM |
| `ip_addresses` | List of IP addresses assigned to the VM |

## Provider Requirements

This module requires the Proxmox provider:

```hcl
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.50"
    }
  }
  required_version = ">= 1.0"
}
```

## Common Use Cases

### Basic VM with Cloud-init

```hcl
module "basic_vm" {
  source = "./modules/proxmox/vm"
  
  name      = "test-vm"
  node_name = "pve-node-01"
  cores     = 2
  memory    = 4096
  
  disks = [
    {
      datastore_id = "local-lvm"
      file_id      = "local:iso/ubuntu-22.04.img"
      interface    = "scsi0"
      size         = 50
    }
  ]
  
  network_devices = [
    { bridge = "vmbr0" }
  ]
  
  ip_configs = [
    {
      address = "192.168.1.100/24"
      gateway = "192.168.1.1"
    }
  ]
  
  ssh_public_key_file = "~/.ssh/id_rsa.pub"
}
```

### Multi-Network VM

```hcl
module "multi_network_vm" {
  source = "./modules/proxmox/vm"
  
  name      = "multi-net-vm"
  node_name = "pve-node-01"
  
  network_devices = [
    { bridge = "vmbr0" },           # Management network
    { bridge = "vmbr1", vlan_id = 100 }  # VLAN network
  ]
  
  ip_configs = [
    {
      address = "192.168.1.100/24"
      gateway = "192.168.1.1"
    },
    {
      address = "10.0.100.50/24"
    }
  ]
}
```

## Integration with Terragrunt

This module is optimized for use with Terragrunt, which provides:

- **DRY Configuration**: Shared variables across environments
- **Remote State Management**: Centralized state handling
- **Dependency Management**: Ordered resource creation
- **Environment Separation**: Isolated configurations per environment

Example Terragrunt structure:
```
├── terragrunt.hcl              # Root configuration
├── _envcommon/
│   └── vm-defaults.hcl         # Shared VM defaults
└── environments/
    ├── dev/
    │   └── my-vm/
    │       └── terragrunt.hcl  # Environment-specific config
    └── prod/
        └── my-vm/
            └── terragrunt.hcl
```

## Best Practices

1. **Use Terragrunt**: Leverage Terragrunt for better organization and DRY principles
2. **Environment Variables**: Always use environment variables for Proxmox credentials
3. **SSH Keys**: Use key-based authentication instead of passwords
4. **Resource Naming**: Use consistent naming conventions across environments
5. **State Management**: Use remote state backends for team collaboration
6. **Version Pinning**: Pin provider versions for reproducible builds

## Troubleshooting

### Common Issues

1. **Authentication Failures**: Verify environment variables are set correctly
2. **Network Issues**: Ensure bridges exist on the target Proxmox node
3. **Storage Problems**: Verify datastore names and available space
4. **Cloud-init Failures**: Check VM console for initialization errors

### Debug Commands

```bash
# Test Proxmox connectivity
curl -k -d "username=user@pam&password=pass" https://proxmox:8006/api2/json/access/ticket

# Terraform debug output
export TF_LOG=DEBUG
terraform apply

# Terragrunt debug
terragrunt apply --terragrunt-log-level debug
```