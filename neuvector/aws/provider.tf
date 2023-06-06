terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "2.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "3.0.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_session_token
  region     = var.aws_region
}

provider "helm" {
  kubernetes {
    config_path = local_file.kube_config_server_yaml.filename
  }
}

provider "rancher2" {
  alias = "bootstrap"

  api_url   = "https://${local.rancher_hostname}"
  insecure  = true
  bootstrap = true
}
