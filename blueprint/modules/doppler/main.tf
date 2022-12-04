# ######################################
# #           DOPPLER
# ######################################

resource "doppler_project" "backend" {
  name = var.doppler_project
  description = var.doppler_project_description
}

resource "doppler_environment" "backend_ci" {
  project = var.doppler_project
  slug = var.root_config
  name = var.doppler_environment
  depends_on = [
    doppler_project.backend
  ]
}
resource "doppler_config" "config" {
  project     = var.doppler_project
  environment = var.root_config
  name        = var.branch_config
  depends_on = [
    doppler_environment.backend_ci
  ]
}

resource "doppler_service_token" "service_token" {
  project = var.doppler_project
  config  = doppler_config.config.name
  name    = var.service_token
  access  = var.service_token_access
}

resource "doppler_secret" "secret" {
  for_each = tomap(var.doppler_secrets)
  project  = var.doppler_project
  config   = doppler_config.config.name
  name     = each.key
  value    = each.value
}





