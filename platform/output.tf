output "cluster-name" {
  description = "cluster name"
  value       = module.gke_standard.cluster_name
}

output "ca_certificate" {
  sensitive = true
  value = module.gke_standard.ca_certificate
}

output "token" {
  sensitive = true
  value = module.gke_standard.client_token
}

output "endpoint" {
  sensitive = true
  value = module.gke_standard.kubernetes_endpoint
}

output "region" {
  value = var.region
}

output "project" {
  value = var.project
}