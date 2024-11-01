locals {
  node_pool_name = "${var.resource_prefix}-${var.node_pool_name}-${var.env}"
  cluster_name   = "${var.resource_prefix}-${var.cluster_name}-${var.env}"
}

module "gke" {
  source                   = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id               = var.project_id
  name                     = local.cluster_name
  regional                 = var.env == "prod" ? true : false
  zones                    = var.env == "prod" ? [] : var.zones
  region                   = var.region
  network                  = var.network
  subnetwork               = var.subnetwork
  ip_range_pods            = var.ip_range_pods_name
  ip_range_services        = var.ip_range_services_name
  enable_private_nodes     = true
  remove_default_node_pool = true
  logging_service          = "none"
  monitoring_service       = "none"

  http_load_balancing        = true
  network_policy             = false
  horizontal_pod_autoscaling = false
  filestore_csi_driver       = false
  dns_cache                  = false
  create_service_account     = true
  deletion_protection        = false

  node_pools = var.env == "prod" ? [
    {
      name         = local.node_pool_name
      machine_type = var.machine_type
      disk_size_gb = var.machine_disk_size
      spot         = false
    },
    ] : [{
      name           = local.node_pool_name
      machine_type   = var.machine_type
      node_locations = "${var.zones[0]}"
      disk_size_gb   = var.machine_disk_size
      spot           = true # Use spot VMs instead of regular on-demand VMs
  }]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    "${local.node_pool_name}" = {
      default-node-pool = true
      env               = var.env
    }
  }

  node_pools_metadata = {
    all = {}

    "${local.node_pool_name}" = {
    }
  }

  node_pools_tags = {
    all = []

    "${local.node_pool_name}" = []
  }
}

#GKE Auth
module "gke_auth" {
  source       = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  project_id   = var.project_id
  location     = module.gke.location
  cluster_name = module.gke.name
  depends_on   = [module.gke.name]
}

resource "google_secret_manager_secret" "gke-cluster-details" {
  project   = var.argocd_project_id # Store the secret in Argo Project
  secret_id = "testsecret123"       # The cluster name should be joined to ArgoCD
  replication {
    auto {

    }
  }
}

resource "google_secret_manager_secret_version" "gke-cluster-details-values" {
  secret = google_secret_manager_secret.gke-cluster-details.id
  secret_data = jsonencode(
    {
      "caData" : module.gke.ca_certificate
      "host" : "https://${module.gke.endpoint}", # The cluster endpoint (Address) that should be joined to ArgoCD
      "clusterName" : module.gke.name            # The cluster project that should be joined to ArgoCD
    }
  )
}