

data "google_client_config" "provider" {}

# data "google_container_cluster" "ml_cluster" {
#   name       = var.cluster_name
#   location   = var.region
#   depends_on = [module.gke_autopilot, module.gke_standard]
#   # depends_on = [module.gke_standard]
#   project = var.project
# }


provider "google" { ## To pull access token to impersonate
#  project = var.project_id
 project 		= "juanie-newsandbox"
 access_token	= data.google_service_account_access_token.default.access_token
 request_timeout 	= "60s"
 region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  host                   = "https://${module.gke_standard.kubernetes_endpoint}"
  token                  = module.gke_standard.client_token //data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke_standard.ca_certificate)
}

provider "kubectl" {
  host  = module.gke_standard.kubernetes_endpoint
  token = module.gke_standard.client_token //data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke_standard.ca_certificate)
}

provider "helm" {
  kubernetes {
    ##config_path = pathexpand("~/.kube/config")
    host  = module.gke_standard.gke[0].endpoint
    token = module.gke_standard.client_token //data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
       module.gke_standard.ca_certificate
    )
  }
}

# module "gke_autopilot" {
#   source = "../modules/gke_autopilot"
#   project_id       = var.project_id
#   region           = var.region
#   cluster_name     = var.cluster_name
#   enable_autopilot = var.enable_autopilot
# }

module "gke_standard" {
  source = "../modules/gke-standard-cluster"
  project_id = var.project_id

  ## network values
  create_network            = var.create_network
  network_name              = var.network_name
  subnetwork_name           = var.subnetwork_name
  subnetwork_cidr           = var.subnetwork_cidr
  subnetwork_region         = var.subnetwork_region
  subnetwork_private_access = var.subnetwork_private_access
  subnetwork_description    = var.subnetwork_description
  network_secondary_ranges  = var.network_secondary_ranges

  ## gke variables
  create_cluster                       = var.create_cluster
  cluster_name                         = var.cluster_name
  cluster_region                       = var.cluster_region
  cluster_zones                        = var.cluster_zones
  ip_range_pods                        = var.ip_range_pods
  ip_range_services                    = var.ip_range_services
  monitoring_enable_managed_prometheus = var.monitoring_enable_managed_prometheus

  ## pools config variables
  cpu_pools                   = var.cpu_pools
  enable_gpu                  = var.enable_gpu
  gpu_pools                   = var.gpu_pools
  enable_tpu                  = var.enable_tpu
  tpu_pools                   = var.tpu_pools
  all_node_pools_oauth_scopes = var.all_node_pools_oauth_scopes
  all_node_pools_labels       = var.all_node_pools_labels
  all_node_pools_metadata     = var.all_node_pools_metadata
  all_node_pools_tags         = var.all_node_pools_tags

}

# module "kubernetes" {
#   source = "../modules/kubernetes"

#   depends_on       = [module.gke_standard]
#   region           = var.region
#   cluster_name     = var.cluster_name
#   enable_autopilot = var.enable_autopilot
#   enable_tpu       = var.enable_tpu
# }

# module "kuberay" {
#   source = "../modules/kuberay"

#   depends_on   = [module.gke_autopilot, module.gke_standard]
#   region       = var.region
#   cluster_name = var.cluster_name
# }
