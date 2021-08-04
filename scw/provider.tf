provider "scaleway" {
  project_id = var.scw_project_id
  access_key = var.scw_access_key
  secret_key = var.scw_secret_key
  zone       = var.scw_zone
  region     = var.scw_region
}

provider "tls" {
}
