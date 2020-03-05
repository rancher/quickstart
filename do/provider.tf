
provider "digitalocean" {
  version = "~> 1.13"
  token   = var.do_token
}

provider "null" {
  version = "~> 2.1"
}
