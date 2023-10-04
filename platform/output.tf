output "cluster-name" {
  description = "cluster name"
  value       = module.gke_standard.cluster_name
}

output "ca_certificate" {
  # value = module.gke_standard.gke[0].ca_certificate
  sensitive = true
  value = module.gke_standard.ca_certificate
}

output "token" {
  # value = module.gke_standard.gke[0].ca_certificate
  sensitive = true
  value = module.gke_standard.client_token
}

output "endpoint" {
  # value = module.gke_standard.gke[0].ca_certificate
  sensitive = true
  value = module.gke_standard.kubernetes_endpoint
}