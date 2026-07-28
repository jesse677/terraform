- apiVersion: v1
  kind: Secret
  metadata:
    name: tina-paper-secrets
    namespace: tina-paper
  type: Opaque
  data:
    ALPACA_API_KEY: "${alpaca_api_key}"
    ALPACA_API_SECRET: "${alpaca_api_secret}"
