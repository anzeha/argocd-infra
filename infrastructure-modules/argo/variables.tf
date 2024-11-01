variable "project_id" {
  type = string
}
variable "env" {
  type        = string
  description = "Environment name"
  validation {
    condition     = var.env == "dev" || var.env == "prod" || var.env == "staging"
    error_message = "Environment variable has to be one of 'env', 'staging' or prod"
  }
}
variable "argocd_namespace" {
  type    = string
  default = "argocd"
}

variable "argo_admin_password" {
  type    = string
  default = "admin"
}

variable "argo_apps" {
  type        = bool
  default     = true
  description = "Deploy ArgoApps"
}

variable "argo_image_updater" {
  type        = bool
  default     = true
  description = "Deploy Argo image updater"
}

variable "github_username" {
  type        = string
  description = "Github username."
  sensitive   = true
  default     = "anzeha"
}

variable "github_token" {
  type      = string
  sensitive = true
}
variable "setup_argocd_ingress" {
  type    = bool
  default = true
}

variable "external_secrets_namespace" {
  type    = string
  default = "external-secrets"
}

variable "external_secrets_gcp_sa_name" {
  type    = string
  default = "external-secrets-sa"
}

variable "external_secrets_ks_sa_name" {
  type    = string
  default = "external-secrets"
}