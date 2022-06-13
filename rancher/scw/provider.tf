terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.2.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "scaleway" {
  project_id = var.scw_project_id
  access_key = var.scw_access_key
  secret_key = var.scw_secret_key
  zone       = var.scw_zone
  region     = var.scw_region
}
