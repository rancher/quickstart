terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.22.0"
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
