module "vpc" {
  source       = "terraform-google-modules/network/google"
  project_id   = var.project_id
  network_name = "${var.resource_prefix}-${var.network}-${var.env}"

  subnets = [
    {
      subnet_name           = "${var.resource_prefix}-${var.subnetwork}-${var.env}"
      subnet_ip             = var.subnet_ip
      subnet_region         = var.region
      subnet_private_access = true
    }
  ]

  secondary_ranges = {
    "${var.resource_prefix}-${var.subnetwork}-${var.env}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = var.ip_cidr_range_pods
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = var.ip_cidr_range_services
      }
    ]
  }
}
