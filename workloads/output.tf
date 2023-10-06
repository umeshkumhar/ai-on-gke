output "gke-namespace" {
  description = "Ray on GKE namespace"
  value       = var.namespace
}

output "jupyterhub-namespace" {
  description = "JupyterHub on GKE namespace"
  value       = var.jupyterhub_namespace
}
