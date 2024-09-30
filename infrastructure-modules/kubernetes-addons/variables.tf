variable "project_id" {
  type = string
}
variable "env" {
  type = string
}
variable "deploy_nginx" {
  type    = bool
  default = true
}
variable "cluster_name" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west4"
}

variable "create_app_namespace" {
  type    = bool
  default = false
}

variable "app_namespace" {
  type    = string
  default = "app-namespace"
}