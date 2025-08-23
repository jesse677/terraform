# Kibana Setup Guide for K3s Logs

## Access Kibana
- **URL**: http://192.168.20.21:30601 (or any K3s node IP with port 30601)
- **Status**: Running and accessible

## Current Data Status
- **Total Documents**: 543,992+ logs indexed
- **Indices**: 
  - `k3s-logs-2025.08.10` (15,831 docs)
  - `k3s-logs-2025.08.11` (528,161+ docs)

## Step-by-Step Setup in Kibana UI

### 1. Create Index Pattern (if needed)
1. Go to **Management** → **Stack Management** → **Index Patterns**
2. Click **Create index pattern**
3. Enter: `k3s-logs-*`
4. Click **Next step**
5. Select `@timestamp` as time field
6. Click **Create index pattern**

### 2. View Your Logs
1. Go to **Analytics** → **Discover**
2. Select the `k3s-logs-*` index pattern from the dropdown
3. Set time range to **Last 24 hours** or **Last 7 days**
4. You should now see your K3s logs!

### 3. Available Log Fields
Your logs contain these fields:
- `@timestamp` - When the log occurred
- `message` - The actual log message  
- `kubernetes.namespace` - Which K8s namespace
- `kubernetes.pod.name` - Which pod generated the log
- `kubernetes.node.name` - Which node the pod is on
- `cluster` - Set to "k3s-cluster"
- `log.file.path` - Original log file path
- `stream` - stdout/stderr
- `container.*` - Container information

### 4. Create Useful Dashboards
Try these searches in Discover:
- `kubernetes.namespace:rook-ceph` - Only Ceph storage logs
- `kubernetes.namespace:elk-stack` - Only ELK stack logs  
- `stream:stderr` - Only error streams
- `message:error OR message:ERROR` - Search for errors

## Troubleshooting

If you still don't see data:

1. **Check time range**: Make sure you're looking at the right time period
2. **Refresh**: Click the refresh button in Kibana
3. **Check index pattern**: Ensure `k3s-logs-*` is selected in Discover

## API Status
Index pattern `k3s-logs-*` has been created programmatically
Default index pattern has been set
543,992+ documents are available in Elasticsearch