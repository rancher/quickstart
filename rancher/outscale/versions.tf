terraform {
  required_providers {
    outscale = {
      source = "outscale-dev/outscale"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
  required_version = ">= 1.0.0"
}
