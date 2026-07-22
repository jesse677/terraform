- apiVersion: v1
  kind: Secret
  metadata:
    name: pve-exporter-credentials
    namespace: kube-prometheus-stack
  type: Opaque
  stringData:
    token-value: "${pve_token_value}"

- apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: pve-exporter
    namespace: kube-prometheus-stack
    labels:
      app: pve-exporter
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: pve-exporter
    template:
      metadata:
        labels:
          app: pve-exporter
      spec:
        containers:
          - name: pve-exporter
            image: prompve/prometheus-pve-exporter:3.9.0
            ports:
              - containerPort: 9221
            env:
              - name: PVE_USER
                value: pve-exporter@pve
              - name: PVE_TOKEN_NAME
                value: monitoring
              - name: PVE_TOKEN_VALUE
                valueFrom:
                  secretKeyRef:
                    name: pve-exporter-credentials
                    key: token-value
              - name: PVE_VERIFY_SSL
                value: "false"
            resources:
              requests:
                cpu: 25m
                memory: 64Mi
              limits:
                cpu: 100m
                memory: 128Mi

- apiVersion: v1
  kind: Service
  metadata:
    name: pve-exporter
    namespace: kube-prometheus-stack
  spec:
    selector:
      app: pve-exporter
    ports:
      - name: http
        port: 9221
        targetPort: 9221
