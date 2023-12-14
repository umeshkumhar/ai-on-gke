# # Copyright 2023 Google LLC
# #
# # Licensed under the Apache License, Version 2.0 (the "License");
# # you may not use this file except in compliance with the License.
# # You may obtain a copy of the License at
# #
# #     http://www.apache.org/licenses/LICENSE-2.0
# #
# # Unless required by applicable law or agreed to in writing, software
# # distributed under the License is distributed on an "AS IS" BASIS,
# # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# # See the License for the specific language governing permissions and
# # limitations under the License.

variable "project_id" {
  type        = string
  description = "GCP project id"
  default     = "umeshkumhar"
}

variable "region" {
  type        = string
  description = "GCP project region or zone"
  default     = "us-central1"
}

variable "private_cluster" {
  type    = bool
  default = true
}

variable "cluster_name" {
  type = string
}

variable "cluster_location" {
  type = string
}

variable "cluster_membership_id" {
  type    = string
  default = "none"
}

variable "kubeconfig_path" {
  type    = string
  default = "~/.kube/config"
}

variable "ray_namespace" {
  type        = string
  description = "Kubernetes namespace where resources are deployed"
  default     = "myray"
}

variable "service_account" {
  type        = string
  description = "Google Cloud IAM service account for authenticating with GCP services"
  default     = "myray-system-account"
}

variable "enable_tpu" {
  type        = bool
  description = "Set to true to create TPU node pool"
  default     = false
}

variable "create_jupyterhub" {
  type        = bool
  description = "Enable creation of jupyterhub"
  default     = true
}

variable "create_jupyterhub_namespace" {
  type        = bool
  description = "Enable creation of jupyterhub namespace if it does not exist"
  default     = false
}

variable "jupyterhub_namespace" {
  type        = string
  description = "Jupyterub Namesapce of GKE"
  # default = myray
}

variable "enable_autopilot" {
  type        = bool
  description = "Enable Autopilot cluster"
  default     = false
}

variable "create_ray" {
  type        = bool
  description = "Enable creation of Ray on GKE"
  default     = true
}

variable "create_triton" {
  type        = bool
  description = "Enable creation of triton"
  default     = false
}

variable "create_triton_namespace" {
  type        = bool
  description = "Enable creation of triton namespace if it does not exist"
  default     = true
}

variable "triton_namespace" {
  type        = string
  description = "Triton Namespace of GKE"
  default     = "triton"
}