#Cloud NAT
resource "google_compute_address" "nat" {
  name    = format("%s-%s-%s-nat-ip", var.resource_prefix, var.cluster_name, var.env)
  project = var.project_id
  region  = var.region
}


module "cloud-nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  project_id                         = var.project_id
  region                             = var.region
  router                             = google_compute_router.this.name
  name                               = format("%s-%s-cloud-nat", var.resource_prefix, var.cluster_name)
  nat_ips                            = ["${google_compute_address.nat.self_link}"]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  depends_on                         = [google_compute_address.nat, google_compute_address.nat]
  subnetworks = [
    {
      name                    = module.vpc.subnets_names[0]
      source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]
      secondary_ip_range_names = [module.vpc.subnets_secondary_ranges[0].0.range_name,
        module.vpc.subnets_secondary_ranges[0].1.range_name
      ]
    }
  ]
}