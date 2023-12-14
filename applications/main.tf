# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

data "google_container_cluster" "default" {
  name     = var.cluster_name
  location = var.cluster_location
}

# provider "kubectl" {
#   host                   = var.private_cluster ? "https://connectgateway.googleapis.com/v1/projects/${data.google_project.project.number}/locations/global/gkeMemberships/${var.cluster_membership_id}" : "https://${data.google_container_cluster.default.endpoint}"
#   token                  = var.private_cluster ? "" : data.google_client_config.default.access_token
#   cluster_ca_certificate = var.private_cluster ? "" : base64decode(data.google_container_cluster.default.master_auth[0].cluster_ca_certificate)
#   dynamic "exec" {
#     for_each = var.private_cluster ? [1] : []
#     content {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       command     = "gke-gcloud-auth-plugin"
#     }
#   }
# }

provider "kubernetes" {
  host                   = var.private_cluster ? "https://connectgateway.googleapis.com/v1/projects/${data.google_project.project.number}/locations/global/gkeMemberships/${var.cluster_membership_id}" : "https://${data.google_container_cluster.default.endpoint}"
  token                  = var.private_cluster ? "" : data.google_client_config.default.access_token
  cluster_ca_certificate = var.private_cluster ? "" : base64decode(data.google_container_cluster.default.master_auth[0].cluster_ca_certificate)
  dynamic "exec" {
    for_each = var.private_cluster ? [1] : []
    content {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "gke-gcloud-auth-plugin"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = var.private_cluster ? "https://connectgateway.googleapis.com/v1/projects/${data.google_project.project.number}/locations/global/gkeMemberships/${var.cluster_membership_id}" : "https://${data.google_container_cluster.default.endpoint}"
    token                  = var.private_cluster ? "" : data.google_client_config.default.access_token
    cluster_ca_certificate = var.private_cluster ? "" : base64decode(data.google_container_cluster.default.master_auth[0].cluster_ca_certificate)
    dynamic "exec" {
      for_each = var.private_cluster ? [1] : []
      content {
        api_version = "client.authentication.k8s.io/v1beta1"
        command     = "gke-gcloud-auth-plugin"
      }
    }
  }
}

module "kuberay-operator" {
  count        = var.create_ray == true ? 1 : 0
  source       = "../modules/kuberay-operator"
  region       = var.region
  cluster_name = var.cluster_name
}

module "kubernetes-nvidia" {
  source           = "../modules/kubernetes-nvidia"
  region           = var.region
  cluster_name     = var.cluster_name
  enable_autopilot = var.enable_autopilot
  enable_tpu       = var.enable_tpu
}

module "kubernetes-namespace" {
  source     = "../modules/kubernetes-namespace"
  depends_on = [module.kubernetes-nvidia, module.kuberay-operator]
  namespace  = var.ray_namespace
}

module "k8s_service_accounts" {
  source          = "../modules/service_accounts"
  project_id      = var.project_id
  namespace       = var.ray_namespace
  service_account = var.service_account
  depends_on      = [module.kubernetes-namespace]
}

module "kuberay-cluster" {
  count      = var.create_ray == true ? 1 : 0
  source     = "../modules/kuberay-cluster"
  depends_on = [module.kubernetes-namespace]
  namespace  = var.ray_namespace
  enable_tpu = var.enable_tpu
}

module "prometheus" {
  count      = var.create_ray == true ? 1 : 0
  source     = "../modules/prometheus"
  depends_on = [module.kuberay-cluster,  module.kubernetes-namespace]
  project_id = var.project_id
  namespace  = var.ray_namespace
}

module "jupyterhub" {
  count            = var.create_jupyterhub == true ? 1 : 0
  source           = "../modules/jupyterhub"
  depends_on       = [module.kuberay-cluster, module.prometheus, module.kubernetes-namespace, module.k8s_service_accounts]
  create_namespace = var.create_jupyterhub_namespace
  namespace        = var.create_jupyterhub_namespace == true ? var.jupyterhub_namespace : var.ray_namespace
}

module "triton" {
  count            = var.create_triton == true ? 1 : 0
  source           = "../modules/triton"
  depends_on       = [module.kuberay-cluster, module.kubernetes-namespace, module.k8s_service_accounts]
  create_namespace = var.create_triton_namespace
  namespace        = var.triton_namespace
}
