# Grafana is deployed separately (../grafana) - don't deploy the bundled one.
grafana:
  enabled: false

# No notification channels configured yet - keep scope to metrics collection
# for now, add alerting later.
alertmanager:
  enabled: false

# k3s runs the scheduler/controller-manager/etcd in-process, bound to
# localhost, and doesn't expose kube-proxy metrics by default - these
# scrape targets would just sit permanently "down" on a stock k3s cluster.
kubeControllerManager:
  enabled: false
kubeScheduler:
  enabled: false
kubeEtcd:
  enabled: false
kubeProxy:
  enabled: false

prometheus:
  prometheusSpec:
    retention: 15d
    resources:
      requests:
        cpu: 200m
        memory: 512Mi
      limits:
        cpu: 500m
        memory: 1Gi
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: local-path
          accessModes:
            - ReadWriteOnce
          resources:
            requests:
              storage: 20Gi

    # pve-exporter (../../manifest/pve-exporter) proxies scrapes through its
    # own /pve endpoint - the real target is the Proxmox host, not the
    # exporter pod itself, so __address__ has to be swapped via relabeling.
    additionalScrapeConfigs:
      - job_name: pve
        static_configs:
          - targets:
              - ${pve_host}
        metrics_path: /pve
        params:
          module: ["default"]
          cluster: ["1"]
          node: ["1"]
        relabel_configs:
          - source_labels: [__address__]
            target_label: __param_target
          - source_labels: [__param_target]
            target_label: instance
          - target_label: __address__
            replacement: pve-exporter.kube-prometheus-stack.svc.cluster.local:9221

prometheusOperator:
  resources:
    requests:
      cpu: 50m
      memory: 128Mi
    limits:
      cpu: 200m
      memory: 256Mi

prometheus-node-exporter:
  resources:
    requests:
      cpu: 50m
      memory: 64Mi
    limits:
      cpu: 100m
      memory: 128Mi

kube-state-metrics:
  resources:
    requests:
      cpu: 50m
      memory: 64Mi
    limits:
      cpu: 100m
      memory: 128Mi
