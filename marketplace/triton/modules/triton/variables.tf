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

variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace where resources are deployed"
}

variable "create_namespace" {
  type        = bool
  description = "Whether to create the Kubernetes namespace where resources are deployed"
  default     = false
}

variable "name" {
  type        = string
  default     = "triton-inference-server"
}

variable "service_account" {
  type        = string
  description = "Google Cloud IAM service account for authenticating with GCP services"
}

variable "temporary_work_dir" {
  type        = string
  description = "Temporary work directory to download sample model data"
  default     = "/tmp"
}

variable "model_repository_folder_name" {
  type        = string
  description = "Name for the sample model data folder"
  default     = "model_repository"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name for sample model data"
  default     = "bucket"
}

variable "bucket_location" {
  type        = string
  description = "Bucket location for sample model data"
  default     = "US"
}