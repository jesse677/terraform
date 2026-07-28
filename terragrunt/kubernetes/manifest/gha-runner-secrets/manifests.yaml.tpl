- apiVersion: v1
  kind: Secret
  metadata:
    name: gha-runner-secrets
    namespace: arc-runners
  type: Opaque
  data:
    github_app_id: "${github_app_id}"
    github_app_installation_id: "${github_app_installation_id}"
    github_app_private_key: "${github_app_private_key}"
