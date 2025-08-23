#!/bin/bash
set -e

# Configuration
K3S_SERVER_IP="${K3S_SERVER_IP:-192.168.20.21}"
KUBECONFIG_PATH="${KUBECONFIG_PATH:-$HOME/.kube/config}"
TOKEN_PATH="$HOME/.k3s-token"

echo "Setting up K3s access..."

# Create .kube directory if it doesn't exist
mkdir -p "$(dirname "$KUBECONFIG_PATH")"

# Remove old host key if it exists (in case of VM recreation)
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$K3S_SERVER_IP" 2>/dev/null || true

# Wait for K3s server to be accessible
echo "Waiting for K3s server to be accessible..."
for i in {1..30}; do
    if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "ubuntu@$K3S_SERVER_IP" "echo 'connected'" > /dev/null 2>&1; then
        echo "K3s server is accessible after $i attempts"
        break
    fi
    echo "Attempt $i: Server not accessible yet, waiting..."
    sleep 10
done

# Copy kubeconfig from K3s server
echo "Copying kubeconfig from K3s server..."
scp -o StrictHostKeyChecking=no "ubuntu@$K3S_SERVER_IP:/etc/rancher/k3s/k3s.yaml" "$KUBECONFIG_PATH"

# Update server address in kubeconfig
sed -i "s/127.0.0.1/$K3S_SERVER_IP/g" "$KUBECONFIG_PATH"

# Configure kubectl to skip TLS verification
kubectl config set-cluster default --insecure-skip-tls-verify=true

# Copy K3s token for direct provider access
echo "Copying K3s token..."
scp -o StrictHostKeyChecking=no "ubuntu@$K3S_SERVER_IP:/home/ubuntu/k3s-token" "$TOKEN_PATH"

# Test connection
echo "Testing K3s connection..."
if kubectl get nodes > /dev/null 2>&1; then
    echo "K3s access configured successfully!"
    echo "Cluster status:"
    kubectl get nodes
else
    echo "Failed to connect to K3s cluster"
    exit 1
fi