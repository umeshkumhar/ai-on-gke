
#######################################################
####    APPLICATIONS
#######################################################

provider "google" {
  project = "umeshkumhar"
}

data "google_client_config" "default" {}

# Defer reading the cluster data until the GKE cluster exists.
data "google_container_cluster" "default" {
  name = "demo-cluster"
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.default.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.default.master_auth[0].cluster_ca_certificate,
  )
}


provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.default.endpoint}"
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.default.master_auth[0].cluster_ca_certificate,
    )
  }
}

resource "helm_release" "hello" {
  name             = "hello-world"
  repository       = "https://helm.github.io/examples"
  chart            = "hello-world"
  namespace        = "default"
  create_namespace = "false"
  cleanup_on_fail  = "true"
}


# module "k8s_service_accounts" {
#   source = "../modules/service_accounts"

#   project_id      = var.project_id
#   namespace       = var.namespace
#   service_account = var.service_account
# }

# module "kuberay" {
#   source     = "../modules/kuberay"
#   depends_on = [module.kubernetes]
#   namespace  = var.namespace
#   enable_tpu = var.enable_tpu
# }

# module "prometheus" {
#   source     = "../modules/prometheus"
#   depends_on = [module.kuberay]
#   project_id = var.project_id
#   namespace  = var.namespace
# }


# module "jupyterhub" {
#   count = var.create_jupyterhub == true ? 1 : 0

#   source           = "../modules/jupyterhub"
#   depends_on       = [module.kuberay, module.prometheus, module.kubernetes]
#   create_namespace = var.create_jupyterhub_namespace
#   namespace        = var.jupyterhub_namespace
# }
