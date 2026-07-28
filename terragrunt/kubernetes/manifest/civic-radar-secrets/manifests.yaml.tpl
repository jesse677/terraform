- apiVersion: v1
  kind: Secret
  metadata:
    name: civic-radar-secrets
    namespace: civic-radar
  type: Opaque
  data:
    session-secret: "${session_secret}"
    pg-password: "${db_password}"
