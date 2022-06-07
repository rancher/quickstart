resource "helm_release" "neuvector" {
  depends_on = [
    helm_release.cert_manager,
    helm_release.cluster_issuer
  ]

  name             = "neuvector"
  chart            = "https://neuvector.github.io/neuvector-helm/core-${var.neuvector_chart_version}.tgz"
  namespace        = "cattle-neuvector-system"
  create_namespace = true
  wait             = true

  values = [
    <<EOT
%{if var.install_rancher}
global:
  cattle:
    url: https://${local.rancher_hostname}/
%{endif}
controller:
  replicas: 1
  apisvc:
    type: ClusterIP
%{if var.install_rancher}
  ranchersso:
    enabled: true
%{endif}
  secret:
    enabled: true
    data:
      sysinitcfg.yaml:
        Cluster_Name: demo
      userinitcfg.yaml:
        users:
        - Fullname: admin
          Username: admin
          Role: admin
          Password: ${var.neuvector_admin_password}
cve:
  scanner:
    replicas: 1
manager:
  ingress:
    enabled: true
    host: ${local.neuvector_hostname}
    annotations:
      cert-manager.io/cluster-issuer: cert-manager-issuers
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    tls: true
    secretName: neuvector-tls-secret

k3s:
  enabled: true
    EOT
  ]
}

locals {
  neuvector_hostname = join(".", ["neuvector", aws_instance.neuvector_server.public_ip, "sslip.io"])
}