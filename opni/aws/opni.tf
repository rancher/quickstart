resource "helm_release" "opni-crd" {
  name             = "opni-crd"
  chart            = "https://raw.githubusercontent.com/rancher/opni/charts-repo/assets/opni-crd/opni-crd-${var.opni_version}.tgz"
  namespace        = "opni"
  create_namespace = true
  wait             = true
}

resource "helm_release" "opni" {
  depends_on = [
    helm_release.cert_manager,
    helm_release.opni-crd,
    helm_release.rancher_server,
    helm_release.longhorn,
  ]

  name             = "opni"
  chart            = "https://raw.githubusercontent.com/rancher/opni/charts-repo/assets/opni/opni-${var.opni_version}.tgz"
  namespace        = "opni"
  create_namespace = true
  wait             = true

  values = [
    <<EOT
replicaCount: 1

disableUsage: false

gateway:
  enabled: true
  serviceType: ClusterIP
  hostname: ${ local.opni_hostname }
  auth:
    provider: noauth
    noauth:
      grafanaHostname: ${ local.grafana_hostname }
  alerting:
    enabled: false
  s3:
    internal: {}
opni-prometheus-crd:
  enabled: false
opni-agent:
  enabled: true
  address: opni
  fullnameOverride: opni-agent
  bootstrapInCluster:
    enabled: true
    managementAddress: opni-internal:11090
  agent:
    version: v2
  kube-prometheus-stack:
    enabled: true
  disableUsage: false
kube-prometheus-stack:
  grafana:
    enabled: false
  prometheus:
    enabled: false
  alertmanager:
    enabled: false
    EOT
  ]
}

locals {
  opni_hostname = aws_elb.opni-lb.dns_name
  grafana_hostname = join(".", ["grafana", aws_instance.opni_server[0].public_ip, "sslip.io"])
  opensearch_hostname = join(".", ["opensearch", aws_instance.opni_server[0].public_ip, "sslip.io"])
}
