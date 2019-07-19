provider "opentelekomcloud" {
  tenant_name = "${var.tenant_name}"
  access_key  = "${var.access_key}"
  secret_key  = "${var.secret_key}"
  region      = "${var.region}"
  auth_url    = "${var.auth_url}"
}
