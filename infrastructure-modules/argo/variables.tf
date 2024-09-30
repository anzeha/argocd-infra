variable "env" {
  type        = string
  description = "Environment name"
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
variable "argo_image_updater_values" {
  type    = string
  default = ""
}
variable "argo_apps_values" {
  type    = string
  default = ""
}
variable "deploy_app" {
  type    = bool
  default = true
}