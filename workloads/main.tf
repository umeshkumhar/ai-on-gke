
#######################################################
####    APPLICATIONS
#######################################################

provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_client_config" "default" {}

data "google_project" "project" {
  project_id = var.project_id
}

provider "kubernetes" {
  host = "https://connectgateway.googleapis.com/v1/projects/${data.google_project.project.number}/locations/global/gkeMemberships/${var.cluster_name}-${var.cluster_region}"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gke-gcloud-auth-plugin"
  }
}

provider "kubectl" {
  config_path = pathexpand(var.kubeconfig_path)
}

provider "helm" {
  kubernetes {
    host = "https://connectgateway.googleapis.com/v1/projects/${data.google_project.project.number}/locations/global/gkeMemberships/${var.cluster_name}-${var.cluster_region}"
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "gke-gcloud-auth-plugin"
    }
  }
}

module "kuberay-operator" {
  source = "../modules/kuberay-operator"
  region       = var.region
  cluster_name = var.cluster_name
}

module "kubernetes-nvidia" {
  source = "../modules/kubernetes-nvidia"
  region           = var.region
  cluster_name     = var.cluster_name
  enable_autopilot = var.enable_autopilot
  enable_tpu       = var.enable_tpu
}

module "kubernetes-namespace" {
  source = "../modules/kubernetes-namespace"
  depends_on      = [module.kubernetes-nvidia, module.kuberay-operator]
  namespace = var.namespace
}

module "k8s_service_accounts" {
  source = "../modules/service_accounts"
  project_id      = var.project_id
  namespace       = var.namespace
  service_account = var.service_account
  depends_on      = [module.kubernetes-namespace]
}

module "kuberay-cluster" {
  source     = "../modules/kuberay-cluster"
  depends_on = [module.kubernetes-namespace]
  namespace  = var.namespace
  enable_tpu = var.enable_tpu
}

module "prometheus" {
  source     = "../modules/prometheus"
  depends_on = [module.kuberay-cluster]
  project_id = var.project_id
  namespace  = var.namespace
}

module "jupyterhub" {
  count = var.create_jupyterhub == true ? 1 : 0
  source           = "../modules/jupyterhub"
  depends_on       = [module.kuberay-cluster, module.prometheus, module.kubernetes-namespace, module.k8s_service_accounts]
  create_namespace = var.create_jupyterhub_namespace
  namespace        = var.jupyterhub_namespace
}
  
resource "helm_release" "hello" {
  name             = "hello-world-cg"
  repository       = "https://helm.github.io/examples"
  chart            = "hello-world"
  namespace        = "default"
  create_namespace = "false"
  cleanup_on_fail  = "true"
}

