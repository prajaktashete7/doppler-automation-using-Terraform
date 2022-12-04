terraform {
  required_version = ">= 0.13.6"
  required_providers {
    doppler = {
      source  = "DopplerHQ/doppler"
      version = "1.1.2"
    }
  }
}

provider "doppler" {
  doppler_token = file("../../blueprint/token.txt")
} 