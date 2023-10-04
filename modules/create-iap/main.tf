# resource "google_project_service" "project_service" {
#   project = var.project_id
#   service = "iap.googleapis.com"
# }

# resource "time_sleep" "wait_for_API" {
#   create_duration = "40s"
#   # depends_on = [google_project_service.project_service]
# }

###############################################################################################
#  run # gcloud iap oauth-brands list
# and select name:  filed output to run the import in next step:
# terraform import google_iap_brand.project_brand projects/868430590303/brands/868430590303
# terraform import google_iap_brand.brand projects/{project}/brands/{project_number} from gcloud projects list

# terraform import module.iap-configuration[0].google_iap_brand.project_brand  projects/868430590303/brands/868430590303  (if it is a module)
# If getting  Error: Error creating Brand: googleapi: Error 409: Requested entity already exists, must do import!
resource "google_iap_brand" "project_brand" {
  support_email     = var.support_email
  application_title = var.application_title
  project           = var.project_id
  # depends_on = [time_sleep.wait_for_API]
}
###############################################################################################

// IAP Client Definition - Will show in https://console.cloud.google.com/apis/credentials?referrer=search&project=ai-sandbox
resource "google_iap_client" "project_client" {
  display_name = "Terraform IAP Test Client"
  brand        =  google_iap_brand.project_brand.name
  # depends_on = [time_sleep.wait_for_API]
}

output "client_id" {
  value       = google_iap_client.project_client.client_id
  description = "The client id of the IAP_client resource"
}

output "secret" {
  value       = google_iap_client.project_client.secret
  description = "The secret of the IAP_client resource"
  sensitive = true
}



