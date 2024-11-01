locals {
  project_id      = "deployment-433913"
  region          = "europe-west4"
  bucket_name     = "${local.project_id}-bucket"
  resource_prefix = "cicd"
}