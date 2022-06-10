resource "helm_release" "cert_manager" {
  depends_on = [local_file.kube_config_server_yaml]

  name             = "cert-manager"
  chart            = "https://charts.jetstack.io/charts/cert-manager-v${var.cert_manager_version}.tgz"
  namespace        = "cert-manager"
  create_namespace = true
  wait             = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "cluster_issuer" {
  depends_on = [helm_release.cert_manager]

  name             = "selfsigned-cluster-issuer"
  chart            = "https://github.com/adfinis-sygroup/helm-charts/releases/download/cert-manager-issuers-0.2.4/cert-manager-issuers-0.2.4.tgz"
  namespace        = "cert-manager"
  create_namespace = true
  wait             = true

  values = [
    <<EOT
clusterIssuers:
- spec:
    selfSigned: {}
    EOT
  ]
}