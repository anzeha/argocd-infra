output "cluster_ca_certificate" {
  # value = data.google_container_cluster.gke.master_auth.0.cluster_ca_certificate
  value     = module.gke.ca_certificate
  sensitive = true
}

output "host" {
  value     = module.gke_auth.host
  sensitive = true
}

output "token" {
  value     = module.gke_auth.token
  sensitive = true
}

output "cluster_name" {
  value = module.gke.name
}