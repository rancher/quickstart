terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "~> 1.13.2"
    }
  }
  required_version = ">= 0.13"
}
