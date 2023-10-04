#######################################################
####    IAP Configuration - OAuth Screen
#######################################################
variable "support_email" {
  type        = string
  description = "Support Admin email"
  //default     = "gcp-organization-admins@juanie.joonix.net"
}

variable "application_title" {
  type        = string
  description = "OAuth Credential Welcome"
  default     = "Sandbox - AI on GKE"
}

variable "project_id" {
  type        = string
  description = "GCP project id"

}