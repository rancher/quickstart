provider "openstack" {
  auth_url                      = var.openstack_auth_url
  cloud                         = var.openstack_cloud
  region                        = var.openstack_region
  user_name                     = var.openstack_user_name
  tenant_name                   = var.openstack_project_name
  password                      = var.openstack_password
  domain_name                   = var.openstack_domain_name
  user_id                       = var.openstack_user_id
  application_credential_id     = var.openstack_application_credential_id
  application_credential_name   = var.openstack_application_credential_name
  application_credential_secret = var.openstack_application_credential_secret
  tenant_id                     = var.openstack_project_id
  token                         = var.openstack_token
  user_domain_name              = var.openstack_user_domain_name
  user_domain_id                = var.openstack_user_domain_id
  project_domain_name           = var.openstack_project_domain_name
  project_domain_id             = var.openstack_project_domain_id
  domain_id                     = var.openstack_domain_id
  insecure                      = var.openstack_insecure
  cacert_file                   = var.openstack_cacert_file
  cert                          = var.openstack_cert
  key                           = var.openstack_key
}

provider "tls" {
}

provider "cloudinit" {
}
