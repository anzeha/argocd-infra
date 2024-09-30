remote_state {
  backend = "gcs"

  generate = {
    path      = "state.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    prefix = "${path_relative_to_include()}/terraform.tfstate"
    bucket   = local.bucket_name
    project  = local.project_id
    location = local.region
  }

}

locals{
  config_vars = read_terragrunt_config("${get_parent_terragrunt_dir()}/config.hcl")
  
  secret_vars = { github_token   = get_env("TF_VAR_github_token")}

  # Extract the variables we need for easy access
  region = local.config_vars.locals.region
  project_id   = local.config_vars.locals.project_id
  bucket_name = local.config_vars.locals.bucket_name
}


generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "google" {
  region  = "${local.region}"
  project = "${local.project_id}"
}
data "google_client_config" "default" {}
EOF
}