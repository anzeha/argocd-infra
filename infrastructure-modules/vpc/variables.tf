variable "env" {
  type        = string
  description = "Environment name"
}

variable "cluster_name" {
  type    = string
  default = "gke-cluster"
}

variable "project_id" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "network" {
  type    = string
  default = "gke-network"
}

variable "region" {
  type    = string
  default = "europe-west4"
}

variable "subnetwork" {
  type    = string
  default = "gke-subnet"
}
variable "ip_range_pods_name" {
  type    = string
  default = "ip-range-pods"
}
variable "ip_range_services_name" {
  type    = string
  default = "ip-range-services"
}
variable "nginx" {
  type    = bool
  default = true
}
variable "subnet_ip" {
  type    = string
  default = "10.10.0.0/16"
}
variable "ip_cidr_range_pods" {
  type    = string
  default = "10.30.0.0/16"
}
variable "ip_cidr_range_services" {
  type    = string
  default = "10.70.0.0/16"
}
variable "argo_cd_namespace" {
  type    = string
  default = "argocd"
}
variable "argo_cd_service_name" {
  type    = string
  default = "argocd-server"
}
