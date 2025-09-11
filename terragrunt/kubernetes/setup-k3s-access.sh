#!/bin/bash
set -e

# Configuration
FIRST_NODE_IP="192.168.20.21"
SSH_USER="ubuntu"
SSH_KEY="~/.ssh/id_rsa"
KUBECONFIG_PATH="$HOME/.kube/config"

echo "Setting up K3s cluster access..."

# Create .kube directory if it doesn't exist
mkdir -p "$HOME/.kube"

# Remove old SSH host keys for the nodes (in case VMs were recreated)
for ip in 192.168.20.21 192.168.20.22 192.168.20.23; do
  ssh-keygen -R "$ip" 2>/dev/null || true
done

# Copy kubeconfig from first server node
echo "Fetching kubeconfig from first server node..."
ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" \
  "${SSH_USER}@${FIRST_NODE_IP}" \
  'sudo cat /etc/rancher/k3s/k3s.yaml' | \
  sed "s/127.0.0.1/${FIRST_NODE_IP}/g" > "$KUBECONFIG_PATH"

# Set proper permissions
chmod 600 "$KUBECONFIG_PATH"

# Copy K3s token for Terraform provider access
echo "Fetching K3s token..."
K3S_TOKEN=$(ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" \
  "${SSH_USER}@${FIRST_NODE_IP}" \
  'sudo cat /var/lib/rancher/k3s/server/node-token')

# Save token to file for Terraform provider
echo "$K3S_TOKEN" > "$HOME/.kube/k3s-token"
chmod 600 "$HOME/.kube/k3s-token"

# Test connection
echo "Testing cluster connection..."
kubectl cluster-info
kubectl get nodes

echo "K3s cluster access configured successfully!"
echo "Kubeconfig: $KUBECONFIG_PATH"
echo "K3s token saved to: $HOME/.kube/k3s-token"