variable "project_id" {
  type = string
}
variable "env" {
  type = string
  description = "Environment name"
  validation {
    condition     = var.env == "dev" || var.env == "prod" || var.env == "staging"
    error_message = "Environment variable has to be one of 'env', 'staging' or prod"
  }
}

variable "resource_prefix" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "gke-cluster"
}
variable "node_pool_name" {
  type    = string
  default = "node-pool"
}
variable "machine_type" {
  type    = string
  default = "e2-standard-2"
}
variable "machine_disk_size" {
  type    = number
  default = 30
  validation {
    condition     = var.machine_disk_size > 0
    error_message = "Machine disk size has to be larger than zero"
  }
}
variable "zones" {
  type    = list(string)
  default = ["europe-west4-a"]
}

variable "region" {
  type    = string
  default = "europe-west4"
}
variable "ip_range_pods_name" {
  type    = string
  default = "ip-range-pods"
}
variable "ip_range_services_name" {
  type    = string
  default = "ip-range-services"
}
variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "argocd_project_id" {
  type = string
}