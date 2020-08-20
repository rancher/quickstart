terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.1.0"
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
