output "kubernetes_endpoint" {
  sensitive = true
  value     = module.gke[0].endpoint
}

output "client_token" {
  sensitive = true
  value     = base64encode(data.google_client_config.default.access_token)
}

output "ca_certificate" {
  value = module.gke[0].ca_certificate
}

output "project_id" {
  value = var.project_id
}

output "region" {
  value = module.gke[0].region
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.gke[0].name
}