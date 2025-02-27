terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.20"
    }
  }
}

provider "google" {
  project     = "peaceful-bruin-450521-c6"
  region      = "us-central1"
  credentials = file("terraform-key.json")
}
