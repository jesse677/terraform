variable "name" {
  description = "Name of the ArgoCD application"
  type        = string
}

variable "namespace" {
  description = "Namespace where ArgoCD is installed"
  type        = string
  default     = "argocd"
}

variable "project" {
  description = "ArgoCD project name"
  type        = string
  default     = "default"
}

variable "repo_url" {
  description = "Git repository URL"
  type        = string
}

variable "target_revision" {
  description = "Git revision to track"
  type        = string
  default     = "main"
}

variable "path" {
  description = "Path within the repository"
  type        = string
  default     = "."
}

variable "destination_server" {
  description = "Kubernetes server URL"
  type        = string
  default     = "https://kubernetes.default.svc"
}

variable "destination_namespace" {
  description = "Target namespace for deployment"
  type        = string
}

variable "automated_prune" {
  description = "Enable automated pruning of resources"
  type        = bool
  default     = true
}

variable "automated_self_heal" {
  description = "Enable automated self-healing"
  type        = bool
  default     = true
}

variable "sync_options" {
  description = "Sync options for the application"
  type        = list(string)
  default     = ["CreateNamespace=true"]
}

variable "finalizers" {
  description = "Finalizers for the application"
  type        = list(string)
  default     = ["resources-finalizer.argocd.argoproj.io"]
}

variable "labels" {
  description = "Labels to apply to the application"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations to apply to the application"
  type        = map(string)
  default     = {}
}