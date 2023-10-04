module "iap-configuration" {
  count  = var.create_iap ? 1 : 0
  source = "./modules/create-iap"
  support_email     = var.support_email
  application_title = var.application_title
  project_id        = var.project_id
}
