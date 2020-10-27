terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.33.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.0.0"
    }
  }
  required_version = ">= 0.13"
}
