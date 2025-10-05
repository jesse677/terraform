# Terraform Infrastructure with Terragrunt

This repository contains Terraform modules and Terragrunt configurations for managing infrastructure with a focus on Proxmox VE virtualization and Kubernetes deployments.

## Repository Structure

```
terraform/
├── .gitignore                   # Git ignore rules for Terraform/Terragrunt
├── modules/                     # Reusable Terraform modules
│   ├── kubernetes/              # Kubernetes-related modules
│   │   ├── argocd-application/  # ArgoCD application deployment
│   │   ├── ceph-cluster/        # Ceph storage cluster
│   │   ├── helm-release/        # Helm chart deployments
│   │   └── rook-operator/       # Rook operator for Ceph
│   └── proxmox/                 # Proxmox VE modules
│       └── vm/                  # Virtual machine management
└── environments/                # Environment-specific configurations
    ├── proxmox/                 # Proxmox infrastructure
    │   ├── k3s-cluster/         # K3s Kubernetes cluster
    │   │   ├── apps/            # K3s applications (ArgoCD, ELK, etc.)
    │   │   └── ceph-cluster/    # Ceph storage deployment
    │   └── setup-k3s-access.sh  # K3s access automation script
    └── vidiforge/               # VidiForge application environment
        └── dev/                 # Development environment
```

## Key Features

### Infrastructure Management
- **Proxmox VE**: Complete VM lifecycle management with cloud-init support
- **K3s Kubernetes**: Lightweight Kubernetes distribution with application-layer resilience
- **Ceph Storage**: Distributed storage using Rook operator within K3s
- **ArgoCD**: GitOps continuous deployment for Kubernetes applications
- **ELK Stack**: Elasticsearch, Logstash, and Kibana for log management

### Architecture Highlights
- **Application-Layer Resilience**: K3s handles node failures through pod rescheduling
- **Local Storage**: Optimal performance with local VM storage
- **Distributed Applications**: Rook-Ceph provides resilient storage within K3s
- **Simple Recovery**: Fast VM provisioning and K3s self-healing

## Prerequisites

1. **Terraform**: Version 1.0 or later
2. **Terragrunt**: Version 0.45 or later
3. **Proxmox VE**: Cluster with API access (8.x recommended)
4. **SSH Key Pair**: For VM access (default: `~/.ssh/id_rsa.pub`)

## Environment Variables

Set these environment variables for Proxmox authentication:

```bash
# Proxmox VE API credentials
export PROXMOX_VE_ENDPOINT="https://your-proxmox-server:8006/"
export PROXMOX_VE_USERNAME="your-username@pam"
export PROXMOX_VE_PASSWORD="your-password"

# Alternative: Use API token instead of password
export PROXMOX_VE_API_TOKEN="your-api-token"
```

## Quick Start

### Deploy K3s Cluster

```bash
# 1. Deploy K3s cluster infrastructure
cd environments/proxmox/k3s-cluster/
terragrunt run-all apply

# 2. Setup automated K3s access
cd ../
./setup-k3s-access.sh

# 3. Deploy Rook-Ceph storage
cd k3s-cluster/ceph-cluster/rook-operator/
terragrunt apply
```

### Deploy Applications

```bash
# Deploy ArgoCD for GitOps
cd ../apps/argocd/
terragrunt apply

# Deploy ELK Stack for logging
cd ../elk-stack/
terragrunt apply
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
- **argocd-application**: Manage ArgoCD applications
- **rook-operator**: Deploy Rook operator for Ceph
- **ceph-cluster**: Configure Ceph storage clusters

## Configuration Management

### Root Configuration (`environments/*/root.hcl`)
Defines shared variables across all resources:
- Network settings (public and cluster networks)
- VM defaults (CPU, memory, storage)
- SSH configuration
- Cloud-init base configuration

### Environment Common (`_envcommon/*.hcl`)
Shared configuration for specific resource types within an environment.

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

## Usage Examples

### Individual Resource Management

```bash
# Navigate to specific resource
cd environments/proxmox/k3s-cluster/k3s-server-01/

# Plan changes
terragrunt plan

# Apply changes
terragrunt apply

# Destroy resource
terragrunt destroy
```

### Bulk Operations

```bash
# Apply all resources in a directory
terragrunt run-all apply

# Plan all resources
terragrunt run-all plan

# Destroy all resources (use with caution)
terragrunt run-all destroy
```

## Security Considerations

- Password authentication disabled on all VMs
- SSH key-based authentication required
- UFW firewall enabled with minimal required access
- Root login disabled via SSH
- No sensitive data committed to repository
- Environment variables used for credentials

## State Management

- Local state files stored per resource directory
- Independent state management for each resource
- `.terragrunt-cache/` directories excluded from git
- Terraform state files excluded from git

## Important Notes

- **Always ask before running apply**: Follow the project instruction to confirm before applying changes
- **Use Terragrunt**: All deployments should use Terragrunt for consistency
- **Update code, not resources**: Manually modifying deployed resources is not recommended
- **Generalized modules**: Modules are designed for reuse across different environments

## Troubleshooting

### Common Issues

1. **SSH Access**: Verify SSH keys are properly configured in root.hcl
2. **Network**: Ensure Proxmox bridges match configuration
3. **Cloud-init**: Check VM console logs for initialization errors
4. **K3s**: Verify network connectivity between cluster nodes

### Debug Commands

```bash
# Check VM status
qm status <vmid>

# View cloud-init logs
sudo cloud-init status --long
sudo journalctl -u cloud-init

# Test connectivity
ssh -i ~/.ssh/id_rsa ubuntu@192.168.20.21

# Terraform debugging
export TF_LOG=DEBUG
terragrunt apply --terragrunt-log-level debug
```

## Contributing

When making changes:
1. Follow existing code conventions and patterns
2. Test changes in development environment first
3. Update documentation as needed
4. Ensure no sensitive information is committed

## License

This project is for internal infrastructure management. Please review and comply with your organization's policies for infrastructure as code.