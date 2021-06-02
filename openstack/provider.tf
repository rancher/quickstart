provider "openstack" {
  auth_url    = var.openstack_auth_url
  user_name   = var.openstack_user_name
  password    = var.openstack_password
  region      = var.openstack_region
  domain_id   = var.openstack_domain_id
  domain_name = var.openstack_domain_name
  tenant_id   = var.openstack_project_id
  tenant_name = var.openstack_project_name
  insecure    = var.openstack_insecure
  cacert_file = var.openstack_cacert_file
}

provider "tls" {
}

provider "cloudinit" {
}
