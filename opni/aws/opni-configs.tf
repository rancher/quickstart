resource "helm_release" "opni-config" {
  depends_on = [helm_release.rancher_server, helm_release.cert_manager, helm_release.opni]
  name       = "opni-config"
  chart      = "./opni-config"
  set {
    name  = "opensearchHostname"
    value = local.opensearch_hostname
  }
  set {
    name  = "grafanaHostname"
    value = local.grafana_hostname
  }
  set {
    name  = "opniAdminHostname"
    value = local.opniadmin_hostname
  }
}
