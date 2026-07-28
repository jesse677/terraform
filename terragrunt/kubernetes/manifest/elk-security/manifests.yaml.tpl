- apiVersion: v1
  kind: Secret
  metadata:
    name: elk-credentials
    namespace: elk
  type: Opaque
  data:
    elastic-password: "${elastic_password}"
    kibana-system-password: "${kibana_system_password}"
    logstash-internal-password: "${logstash_internal_password}"
    kibana-encryption-key: "${kibana_encryption_key}"

- apiVersion: v1
  kind: Secret
  metadata:
    name: elk-elasticsearch-certs
    namespace: elk
  type: Opaque
  data:
    elastic-certificates.p12: "${elasticsearch_certs_p12}"
