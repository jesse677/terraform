# Terraform Infrastructure with Terragrunt

This repository contains Terraform modules and Terragrunt configurations for managing infrastructure with a focus on Proxmox VE virtualization and Kubernetes deployments.

## Key Features

### Infrastructure Management
- **Proxmox VE**: Complete VM lifecycle management with cloud-init support
- **K3s Kubernetes**: Lightweight Kubernetes distribution with application-layer resilience
- **ArgoCD**: GitOps continuous deployment for Kubernetes applications

## Prerequisites

1. **Terraform**: Version 1.0 or later
2. **Terragrunt**: Version 0.45 or later
3. **Proxmox VE**: Cluster with API access (8.x recommended)

## Environment Variables

```bash
# Proxmox VE API credentials
export PROXMOX_VE_ENDPOINT="https://your-proxmox-server:8006/"
export PROXMOX_VE_USERNAME="your-username@pam"
export PROXMOX_VE_PASSWORD="your-password"

# Alternative: Use API token instead of password
export PROXMOX_VE_API_TOKEN="your-api-token"
```

## Modules

### Proxmox VM Module (`modules/proxmox/vm/`)
- Complete VM lifecycle management
- Cloud-init integration with user data
- Multiple network interfaces with VLAN support
- Flexible disk configuration
- SSH key management
- High availability support (optional)

### Kubernetes Modules (`modules/kubernetes/`)
- **helm-release**: Deploy Helm charts to Kubernetes

## Configuration Management

### Root Configuration (`environments/*/root.hcl`)
Defines shared variables across all resources:
- Network settings (public and cluster networks)
- VM defaults (CPU, memory, storage)
- SSH configuration
- Cloud-init base configuration

### Resource-Specific Configuration
Each resource has its own `terragrunt.hcl` with specific settings.

## Key Infrastructure Components

### Network Configuration
- **Public Network**: `192.168.20.0/24` - Management and external access
- **Cluster Network**: `192.168.30.0/24` - Internal K3s cluster communication
- **Bridges**: `vmbr0` (public) and `vmbr1` (cluster)

### K3s Cluster Layout
- **k3s-server-01**: `192.168.20.21` - Control plane node
- **k3s-agent-01**: `192.168.20.22` - Worker node
- **k3s-agent-02**: `192.168.20.23` - Worker node
