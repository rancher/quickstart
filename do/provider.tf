provider "digitalocean" {
  version = "1.13.0"
  token   = var.do_token
}

provider "tls" {
  version = "2.1.1"
}
