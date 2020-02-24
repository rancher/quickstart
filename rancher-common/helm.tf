# Helm resources

# Install cert-manager helm chart
resource "helm_release" "cert_manager" {
  depends_on = [
    kubernetes_job.install_certmanager_crds,
    kubernetes_service_account.cert_manager_crd,
    kubernetes_cluster_role_binding.cert_manager_crd_admin,
  ]

  repository = data.helm_repository.jetstack.metadata[0].name
  name       = "cert-manager"
  chart      = "cert-manager"
  version    = "v${var.cert_manager_version}"
  namespace  = "cert-manager"
}

# Install Rancher helm chart
resource "helm_release" "rancher_server" {
  depends_on = [
    helm_release.cert_manager,
  ]

  repository = data.helm_repository.rancher_latest.metadata[0].name
  name       = "rancher"
  chart      = "rancher"
  version    = var.rancher_version
  namespace  = "cattle-system"

  set {
    name  = "hostname"
    value = var.rancher_server_dns
  }

  set {
    name  = "certmanager.version"
    value = var.cert_manager_version
  }
}
