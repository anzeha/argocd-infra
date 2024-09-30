module "gke" {
  source                   = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id               = var.project_id
  name                     = "${var.resource_prefix}-${var.cluster_name}-${var.env}"
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

  node_pools = [
    {
      name         = "${var.resource_prefix}-${var.node_pool_name}-${var.env}"
      machine_type = var.machine_type
      # node_locations = var.env == "prod" ? null :  "${var.zones[0]}"
      #TODO
      node_locations = "${var.zones[0]}"
      disk_size_gb   = var.machine_disk_size
      spot           = true
      #   service_account = "gke-terraform@${var.project_id}.iam.gserviceaccount.com"
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
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
