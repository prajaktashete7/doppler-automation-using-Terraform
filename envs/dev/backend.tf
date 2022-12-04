terraform {
  backend "gcs" {
    bucket = "devops-project-tfstates"
    prefix = "main/"
  }
}