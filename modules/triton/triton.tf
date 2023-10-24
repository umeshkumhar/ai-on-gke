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


resource "random_id" "bucket_id" {
  byte_length = var.random_id_byte_length
}

resource "google_storage_bucket" "bucket" {
  name     = "${var.bucket_name}-${random_id.bucket_id.hex}"
  location = var.bucket_location
  project  = var.project_id
}

resource "google_storage_bucket_iam_binding" "bucket-iam-binding" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/default]",
  ]
}

resource "null_resource" "git_clone" {
  provisioner "local-exec" {
    command = "mkdir -v ${var.temporary_work_dir}/server && git clone https://github.com/triton-inference-server/server.git ${var.temporary_work_dir}/server"
  }
}

resource "null_resource" "upload_folder" {
  depends_on = [null_resource.git_clone]

  provisioner "local-exec" {
    command = <<EOF
    ${var.temporary_work_dir}/server/docs/examples/fetch_models.sh
    cp -vr model_repository/ ${var.temporary_work_dir}/server/docs/examples/
    gsutil -m cp -r ${var.temporary_work_dir}/server/docs/examples/model_repository gs://${google_storage_bucket.bucket.name}/${var.model_repository_folder_name}
    EOF
  }
}

resource "null_resource" "enable_gmp_metrics" {
  depends_on = [null_resource.git_clone]

  provisioner "local-exec" {
    command = <<EOF
    sed -i 's/apiVersion: monitoring.coreos.com\/v1/apiVersion: monitoring.googleapis.com\/v1/' /${var.temporary_work_dir}/server/deploy/gcp/templates/service.yaml
    sed -i 's/kind: ServiceMonitor/kind: PodMonitoring/' /${var.temporary_work_dir}/server/deploy/gcp/templates/service.yaml
    EOF
  }
}

resource "helm_release" "triton-inference-server" {
  depends_on       = [null_resource.enable_gmp_metrics]
  name             = var.helm_release_name
  namespace        = var.namespace
  create_namespace = var.create_namespace
  chart            = "${var.temporary_work_dir}/server/deploy/gcp"
  set {
    name  = "image.modelRepositoryPath"
    value = "gs://${google_storage_bucket.bucket.name}/${var.model_repository_folder_name}"
  }
}