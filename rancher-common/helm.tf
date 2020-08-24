# Helm resources

# Install cert-manager helm chart
resource "helm_release" "cert_manager" {
  depends_on = [
    k8s_manifest.cert_manager_crds,
  ]

  repository       = "https://charts.jetstack.io"
  name             = "cert-manager"
  chart            = "cert-manager"
  version          = "v${var.cert_manager_version}"
  namespace        = "cert-manager"
  create_namespace = true
}

# Install Rancher helm chart
resource "helm_release" "rancher_server" {
  depends_on = [
    helm_release.cert_manager,
  ]

  repository       = "https://releases.rancher.com/server-charts/latest"
  name             = "rancher"
  chart            = "rancher"
  version          = var.rancher_version
  namespace        = "cattle-system"
  create_namespace = true

  set {
    name  = "hostname"
    value = var.rancher_server_dns
  }

  set {
    name  = "certmanager.version"
    value = var.cert_manager_version
  }
}
