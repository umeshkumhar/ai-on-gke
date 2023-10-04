terraform {
  backend "gcs" {
    bucket = "juanie-state-bucket"
    prefix                      = "terraform/ai-on-gke/user"
    # impersonate_service_account = "terraform-sa@juanie-newsandbox.iam.gserviceaccount.com" # Only if impersonating
  }
}