provider "google" {
  version = "3.6.0"

  credentials = file(var.gcp_account_json)
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

provider "tls" {
  version = "2.1.1"
}
