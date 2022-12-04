# ######################################
# #           DOPPLER
# ######################################

variable "doppler_project" {
  type        = string
  default     = ""
  description = "Name of the Doppler project where you define the app config and secrets for a single service or application."
}
variable "doppler_project_description" {
  type = string
  default = ""
  description = "The main backend project"
}
variable "doppler_environment" {
  type        = string
  default     = ""
  description = "Name of the doppler enviornment.  three default environments for defining configuration at the root level: Development, Staging, and Production."
}
variable "doppler_environment_description" {
  type        = string
  default     = ""
  description = "Description of the doppler enviornment.  three default environments for defining configuration at the root level: Development, Staging, and Production."
}
variable "root_config" {
  type        = string
  default     = ""
  description = "Name of doppler root config associated with perticular enviornment.  Configs are responsible for vaulting and managing app config and secrets such as API keys, database urls, certs, etc"
}
variable "branch_config" {
  type        = string
  default     = ""
  description = "Name of branch doppler config associated with perticular enviornment.  Configs are responsible for vaulting and managing app config and secrets such as API keys, database urls, certs, etc"
}
variable "service_token" {
  type        = string
  default     = ""
  description = "Name of the doppler scervice token. A Doppler Service Token provides read-only secrets access to a specific config within a project."
}
variable "service_token_access" {
  type        = string
  default     = ""
  description = "access provided to service token. ex. read, write, read/write"
}
variable "doppler_secrets" {
  description = "List of custom rule definitions (refer to variables file for syntax)."
  type        = map(string)
  default     = {}
}

