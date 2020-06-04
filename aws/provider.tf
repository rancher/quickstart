provider "aws" {
  version = "2.41.0"

  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

provider "tls" {
  version = "2.1.1"
}
