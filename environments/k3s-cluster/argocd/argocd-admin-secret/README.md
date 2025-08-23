# ArgoCD Admin Secret

This module creates a Kubernetes secret for the ArgoCD admin password.

## Usage

Set the admin password using the environment variable:
```bash
export ARGOCD_ADMIN_PASSWORD="your-secure-password"
```

Then deploy:
```bash
terragrunt apply
```

## Notes

- The secret is created in the `argocd` namespace
- The secret name is `argocd-initial-admin-secret`
- If no environment variable is set, a placeholder password will be used
- The ArgoCD helm chart deployment depends on this secret being created first