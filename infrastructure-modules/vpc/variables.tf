variable "env" {
  type        = string
  description = "Environment name"
  validation {
    condition     = var.env == "dev" || var.env == "prod" || var.env == "staging"
    error_message = "Environment variable has to be one of 'env', 'staging' or prod"
  }
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
  validation {
    condition     = can(cidrhost(var.subnet_ip, 0))
    error_message = "The CIDR block must be in a valid format, such as 192.168.1.0/24."
  }
}
variable "ip_cidr_range_pods" {
  type    = string
  default = "10.30.0.0/16"
  validation {
    condition     = can(cidrhost(var.ip_cidr_range_pods, 0))
    error_message = "The CIDR block must be in a valid format, such as 192.168.1.0/24."
  }
}
variable "ip_cidr_range_services" {
  type    = string
  default = "10.70.0.0/16"
  validation {
    condition     = can(cidrhost(var.ip_cidr_range_services, 0))
    error_message = "The CIDR block must be in a valid format, such as 192.168.1.0/24."
  }
}
variable "argo_cd_namespace" {
  type    = string
  default = "argocd"
}
variable "argo_cd_service_name" {
  type    = string
  default = "argocd-server"
}
