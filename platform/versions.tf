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

# terraform {
#   required_providers {
#     google = {
#       source = "hashicorp/google"
#     }
#     google-beta = {
#       source  = "hashicorp/google-beta"
#       version = "~> 4.8"
#     }
#     helm = {
#       source  = "hashicorp/helm"
#       version = "~> 2.8.0"
#     }
#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = "2.18.1"
#     }
#     kubectl = {
#     source  = "alekc/kubectl"
#     version = "2.0.1"
#     }
#   }
# }

# provider "google" {
#   access_token    = data.google_service_account_access_token.default.access_token
#   request_timeout = "60s"
#   project         = var.project_id
#   region          = var.region
#   # project = "juanie-newsandbox"
#   # region  = "us-central1"
#   # zone    = "us-central1-a"
# }

# provider "google-beta" {
#   project = var.project_id
#   region  = var.region
# }

# provider "kubernetes" {
#   host  = data.google_container_cluster.gke-cluster.endpoint
#   token = data.google_client_config.provider.access_token
#   cluster_ca_certificate = base64decode(
#     data.google_container_cluster.gke-cluster.master_auth[0].cluster_ca_certificate
#   )
# }

# provider "kubectl" {
#   host  = data.google_container_cluster.gke-cluster.endpoint
#   token = data.google_client_config.provider.access_token
#   cluster_ca_certificate = base64decode(
#     data.google_container_cluster.gke-cluster.master_auth[0].cluster_ca_certificate
#   )
# }

# provider "helm" {
#   kubernetes {
#     ##config_path = pathexpand("~/.kube/config")
#     host  = data.google_container_cluster.ml_cluster.endpoint
#     token = data.google_client_config.provider.access_token
#     cluster_ca_certificate = base64decode(
#       data.google_container_cluster.ml_cluster.master_auth[0].cluster_ca_certificate
#     )
#   }
# }


# provider "kubernetes" {
#   host                   = "https://${module.gke-autopilot.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(module.gke-autopilot.ca_certificate)
# }


terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.8"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.8.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.0.1"
    }
  }
  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-kubernetes-engine:kuberay/v0.1.0"
  }
}