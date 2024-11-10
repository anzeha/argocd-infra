terraform {
  source = "git::https://github.com/anzeha/infra-modules.git//kubernetes-addons?ref=v0.0.6"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}


dependency "cluster" {
  config_path = "../cluster"
  mock_outputs = {
    cluster_ca_certificate = "sample-ceritifcate"
    host                   = "sample-host"
    token                  = "token"
    cluster_name           = "sample-name"
  }
}

// dependency "eks_cluster_staging" {
//   config_path = "../../../../infrastructure-live/app-clusters/staging/vpc"
//     mock_outputs = {
//       service_account_key = "sample-account-key"
//     }
// }


generate "kubernetes_provider" {
  path      = "kubernetes-provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "kubernetes" {
  cluster_ca_certificate = base64decode("${dependency.cluster.outputs.cluster_ca_certificate}")
  host                   = "${dependency.cluster.outputs.host}"
  token                  = "${dependency.cluster.outputs.token}"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gke-gcloud-auth-plugin"
  }
}
provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode("${dependency.cluster.outputs.cluster_ca_certificate}")
    host                   = "${dependency.cluster.outputs.host}"
    token                  = "${dependency.cluster.outputs.token}"
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "gke-gcloud-auth-plugin"
    }
  }
}
EOF
}

locals {
  env = include.env.locals.env
}


inputs = {
  env        = local.env
  project_id = include.root.locals.project_id

  cluster_name = dependency.cluster.outputs.cluster_name
}
