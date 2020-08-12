terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.33.0"
    }
    local = {
      source = "hashicorp/local"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "2.2.0"
    }
  }
  required_version = ">= 0.13"
}
