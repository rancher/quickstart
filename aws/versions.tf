terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.12.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.0.0"
    }
    susepubliccloud = {
      source = "SUSE/susepubliccloud"
      version = "0.0.4"
    }
  }
  required_version = ">= 0.13"
}
