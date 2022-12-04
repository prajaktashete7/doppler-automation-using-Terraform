######################################
#        Random DB password
######################################

resource "random_password" "db_password" {
  length  = 32
  special = true
}
######################################
#           DOPPLER
######################################

module "dev_infra" {
  source               = "../../../blueprint/modules/doppler"
  doppler_project      = "tf-test-project"
  doppler_environment  = "development"
  root_config          = "dev"
  branch_config        = "dev_prajakta"
  service_token        = "tf test service Token"
  service_token_access = "read/write"
  doppler_secrets = {
    "DB_PASSWORD" = random_password.db_password.result
  }
}

