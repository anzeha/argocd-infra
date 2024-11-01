resource "google_compute_address" "ingress" {
  count   = var.deploy_nginx ? 1 : 0
  name    = format("%s-ingress-ip", var.cluster_name)
  project = var.project_id
  region  = var.region
}


module "nginx-controller" {
  count  = var.deploy_nginx ? 1 : 0
  source = "terraform-iaac/nginx-controller/helm"

  ip_address = google_compute_address.ingress[0].address

}
