output "vpc_network_name" {
  value = module.vpc.network_name
}
output "vpc_subnetwork_name" {
  value = module.vpc.subnets_names[0]
}
# output "service_account_key" {
#   value = length(google_service_account_key.this) > 0 ? google_service_account_key.this[0].private_key : "Resource not created"
#   sensitive = true
# }