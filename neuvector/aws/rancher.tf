resource "helm_release" "rancher_server" {
  count = var.install_rancher ? 1 : 0
  depends_on = [
    helm_release.cert_manager,
  ]

  name             = "rancher"
  chart            = "${var.rancher_helm_repository}/rancher-${var.rancher_version}.tgz"
  namespace        = "cattle-system"
  create_namespace = true
  wait             = true

  set {
    name  = "hostname"
    value = local.rancher_hostname
  }

  set {
    name  = "replicas"
    value = "1"
  }

  set {
    name  = "bootstrapPassword"
    value = "admin" # TODO: change this once the terraform provider has been updated with the new pw bootstrap logic
  }
}

resource "rancher2_bootstrap" "admin" {
  count = var.install_rancher ? 1 : 0

  depends_on = [
    helm_release.rancher_server
  ]

  provider = rancher2.bootstrap

  password  = var.rancher_server_admin_password
  telemetry = true
}

locals {
  rancher_hostname = join(".", ["rancher", aws_instance.neuvector_server.public_ip, "sslip.io"])
}