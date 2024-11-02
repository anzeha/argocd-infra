terraform {
  source = "git::https://github.com/anzeha/infra-modules.git//cluster?ref=v0.0.5"
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

locals {
  env          = include.env.locals.env
  machine_type = include.env.locals.machine_type
}


inputs = {
  env        = local.env
  project_id = include.root.locals.project_id

  resource_prefix = include.root.locals.config_vars.locals.resource_prefix

  network    = dependency.vpc.outputs.vpc_network_name
  subnetwork = dependency.vpc.outputs.vpc_subnetwork_name

  machine_type      = local.machine_type
  argocd_project_id = include.root.locals.project_id


}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_network_name    = "example-network"
    vpc_subnetwork_name = "example-subnetwork"
  }
}
