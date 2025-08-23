# Proxmox Infrastructure with Terragrunt

This repository contains Terraform modules and Terragrunt configurations for managing Proxmox VE infrastructure with High Availability support.

## Repository Structure

```
terragrunt-proxmox/
├── root.hcl                          # Generic VM defaults
├── setup-k3s-access.sh               # Automated K3s access setup
├── k3s-cluster/
│   ├── k3s-root.hcl                 # K3s-specific configuration
│   ├── k3s-server-01/               # K3s control plane
│   ├── k3s-agent-01/                # K3s worker node 1
│   └── k3s-agent-02/                # K3s worker node 2
├── ceph-cluster/
│   ├── rook-operator/               # Rook-Ceph operator
│   └── ceph-cluster/                # Ceph storage cluster
└── terraform-modules/
    └── modules/
        ├── vm/                      # VM module with HA support
        ├── rook-operator/           # Rook operator module
        └── ceph-cluster/            # Ceph cluster module
```

## K3s Cluster Design Philosophy

### Application-Layer Resilience

This K3s deployment uses **application-layer resilience** instead of VM-level HA:

- **K3s Built-in Resilience**: K3s automatically handles node failures by rescheduling pods to healthy nodes
- **Local Storage**: Each VM uses local storage (`local-lvm`) for optimal performance
- **Simplified Architecture**: No shared storage complexity or VM migration overhead
- **Resource Efficiency**: Full storage allocation per VM (~100GB each)

### Resilience Features

- **Pod Rescheduling**: Workloads automatically move to healthy nodes
- **Cluster Self-Healing**: K3s cluster maintains quorum and functionality
- **Storage Independence**: Rook-Ceph provides distributed storage within K3s
- **Fast Recovery**: New VMs can be provisioned quickly if needed

### High Availability Options

The VM module includes HA support for other use cases requiring VM-level failover. To enable HA for other VMs:

```hcl
inputs = {
  ha_enabled = true
  ha_group   = "production"
  # Requires shared storage (Ceph, NFS, etc.)
}
```

## Standard Prerequisites

1. **Terraform**: Version 1.0 or later
2. **Terragrunt**: Version 0.45 or later  
3. **Proxmox VE**: Cluster with API access (8.x recommended)
4. **BPG Proxmox Provider**: Latest version (>=0.79.0)
5. **SSH Key Pair**: For VM access (default: `~/.ssh/id_rsa.pub`)

## Environment Variables

The following environment variables are required for Proxmox authentication:

```bash
# Proxmox VE API credentials
export PROXMOX_VE_ENDPOINT="https://your-proxmox-server:8006/"
export PROXMOX_VE_USERNAME="your-username@pam"
export PROXMOX_VE_PASSWORD="your-password"

# Alternative: Use API token instead of password
export PROXMOX_VE_API_TOKEN="your-api-token"
```

## Configuration Overview

### Root Configuration (`root.hcl`)

The root configuration defines shared variables used across all VMs:

- **Network Configuration**: Public and cluster network settings
- **VM Defaults**: CPU cores, memory, username settings  
- **Storage**: Disk templates, datastores, and sizes
- **Cloud-init**: Base packages and initialization commands
- **SSH**: Public key configuration for authentication

### Environment Common (`_envcommon/k3s-node.hcl`)

Shared configuration for all K3s nodes that includes common inputs from the root configuration.

### Node-Specific Configurations

Each VM has its own `terragrunt.hcl` file with:

- **Node Identity**: Name, Proxmox node assignment, IP addresses
- **Cloud-init User Data**: Custom initialization scripts
- **K3s Configuration**: Server vs agent-specific setup

## Key Infrastructure Components

### Network Configuration

- **Public Network**: `192.168.20.0/24` - Management and external access
- **Cluster Network**: `192.168.30.0/24` - Internal K3s cluster communication
- **Bridges**: `vmbr0` (public) and `vmbr1` (cluster)

### VM Specifications

- **CPU**: 4 cores per VM
- **Memory**: 8192 MB (8 GB) per VM  
- **Disk**: 100 GB using Ubuntu 22.04 LTS cloud image
- **OS**: Ubuntu 22.04 LTS (Jammy)

### K3s Cluster Layout

- **k3s-server-01**: `192.168.20.21` - Master node
- **k3s-agent-01**: `192.168.20.22` - Worker node  
- **k3s-agent-02**: `192.168.20.23` - Worker node

## Usage

### K3s Cluster Deployment

Simple deployment process leveraging K3s's built-in resilience:

```bash
# 1. Deploy all K3s nodes
cd k3s-cluster/
terragrunt run-all apply

# 2. Setup automated K3s access
cd ../
./setup-k3s-access.sh

# 3. Deploy Rook-Ceph storage cluster
cd ceph-cluster/rook-operator
terragrunt apply
cd ../ceph-cluster  
terragrunt apply
```

### Alternative HA Deployment

For other VMs requiring VM-level HA, create an HA group first:

```bash
# Only needed for VMs with ha_enabled = true
terragrunt apply --terragrunt-config ha-group.hcl
```

### Manage Individual VMs

```bash
# Navigate to specific VM directory
cd k3s-cluster/k3s-server-01/

# Plan changes
terragrunt plan

# Apply changes
terragrunt apply

# Destroy VM
terragrunt destroy
```

### View All VM Status

```bash
# From the k3s-cluster directory
terragrunt run-all plan
```

## Cloud-init Configuration

Each VM includes comprehensive cloud-init configuration:

- **Package Management**: Automatic updates and base package installation
- **User Setup**: Ubuntu user with sudo privileges and SSH key authentication
- **SSH Security**: Key-based authentication only, password auth disabled
- **Networking**: Static IP configuration and hostname setup
- **K3s Installation**: Automated K3s server/agent deployment
- **Security**: UFW firewall and proper service initialization

## Terraform Module

The VMs use a custom Terraform module located at `../../../terraform-modules/modules/proxmox/vm` which provides:

- Proxmox VM resource management
- Cloud-init file handling
- Network and storage configuration
- SSH key management

## Security Notes

- Password authentication is disabled on all VMs
- SSH access requires private key authentication
- UFW firewall is enabled with SSH access allowed
- Root login is disabled via SSH
- All VMs run with minimal required services

## Customization

To customize the infrastructure:

1. **Modify `root.hcl`** for global changes (network, VM specs, packages)
2. **Edit individual `terragrunt.hcl`** files for node-specific changes
3. **Update cloud-init user data** for custom initialization scripts
4. **Adjust network settings** for different network topologies

## State Management

- **Backend**: Local state files stored in each VM directory
- **State Files**: `terraform.tfstate` and backup files
- **Isolation**: Each VM maintains independent state

## Troubleshooting

### Common Issues

1. **SSH Access Problems**: Ensure your public key is properly configured in `root.hcl`
2. **Network Connectivity**: Verify Proxmox bridge configurations match network settings
3. **Cloud-init Failures**: Check VM console logs in Proxmox for initialization errors
4. **K3s Installation Issues**: Verify network connectivity between nodes

### HA Troubleshooting Commands

```bash
# Check HA status and resources
pvesh get /cluster/ha/status
pvesh get /cluster/ha/resources  
pvesh get /cluster/ha/groups

# Check cluster status
pvecm status
pvecm nodes

# Manual VM migration (if needed)
pvesh create /nodes/{node}/qemu/{vmid}/migrate -target {target-node}

# Force migration with downtime
pvesh create /nodes/{node}/qemu/{vmid}/migrate -target {target-node} -force 1
```

### Standard VM Commands

```bash
# Check VM status in Proxmox
qm status <vmid>

# View cloud-init logs on VM
sudo cloud-init status --long
sudo journalctl -u cloud-init

# Test SSH connectivity
ssh -i ~/.ssh/id_rsa ubuntu@192.168.20.21
```

## Important Design Considerations

### K3s Resilience Strategy
- **Application-Layer**: K3s handles node failures through pod rescheduling and cluster self-healing
- **Local Storage**: Each VM uses `local-lvm` for optimal performance (~100GB per VM)
- **Rook-Ceph**: Provides distributed storage within the K3s cluster for persistent volumes
- **Simple Architecture**: No shared storage complexity or VM migration dependencies

### Network Configuration
- Ensure network bridges (`vmbr0`, `vmbr1`) exist on all nodes
- VLANs and network configuration must be consistent across the cluster
- K3s cluster network: `192.168.30.0/24` for internal communication
- Public network: `192.168.20.0/24` for external access

### Storage Architecture
- **VM Storage**: Local LVM on each Proxmox node
- **K3s Storage**: Rook-Ceph cluster using `/dev/sdb` from each VM
- **Persistent Volumes**: Provided by Rook-Ceph for application data
- **High Performance**: Local VM storage with distributed application storage

### Recovery Strategy
- **Node Failure**: K3s reschedules pods to healthy nodes automatically
- **VM Replacement**: Terraform can quickly provision new VMs if needed
- **Data Protection**: Rook-Ceph provides replication and fault tolerance
- **Service Continuity**: Applications remain available during node failures