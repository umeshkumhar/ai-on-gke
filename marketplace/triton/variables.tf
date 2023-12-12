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

variable "cluster_name" {
  type = string
}

variable "cluster_location" {
  type = string
}

variable "triton_version" {
  type        = string
  default = "v1.1.1"
}

variable "triton_namespace" {
  type        = string
  description = "Triton Namespace of GKE, if doesnot exist"
  default     = "triton"
}

variable "service_account" {
  type        = string
  description = "Google Cloud IAM service account for authenticating with GCP services"
  default     = "<your user name>-system-account"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name with absolute path for sample model data"
  default     = "bucket"
}

variable "bucket_location" {
  type        = string
  description = "Bucket location for sample model data"
  default     = "US"
}