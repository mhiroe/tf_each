terraform {
  required_version = "~> 0.13.6"
}

provider "google" {
  project = var.project
  region  = var.region
}

