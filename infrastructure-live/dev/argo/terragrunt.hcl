terraform {
  source = "../../../infrastructure-modules/argo"
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


inputs = {

  env = include.env.locals.env

  github_username = "anzeha"
  github_token    = include.root.locals.secret_vars.github_token

  argo_image_updater_values = "${file("./values/argo-image-updater.values.yml")}"
  argo_apps_values          = "${file("./values/argo-apps.values.yml")}"

  argo_apps          = true
  argo_image_updater = true
}

dependency "eks_cluster" {
  config_path = "../cluster"

  mock_outputs = {
    cluster_ca_certificate = "sample-ceritifcate"
    host                   = "sample-host"
    token                  = "token"
  }
}

generate "kubernetes_provider" {
  path      = "kubernetes-provider-test.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "kubernetes" {
  cluster_ca_certificate = base64decode("${dependency.eks_cluster.outputs.cluster_ca_certificate}")
  host                   = "${dependency.eks_cluster.outputs.host}"
  token                  = "${dependency.eks_cluster.outputs.token}"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gke-gcloud-auth-plugin"
  }
}
provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode("${dependency.eks_cluster.outputs.cluster_ca_certificate}")
    host                   = "${dependency.eks_cluster.outputs.host}"
    token                  = "${dependency.eks_cluster.outputs.token}"
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "gke-gcloud-auth-plugin"
    }
  }
}
EOF
}
