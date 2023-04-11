resource "helm_release" "longhorn" {
  name             = "longhorn"
  chart            = "https://github.com/longhorn/charts/releases/download/longhorn-${var.longhorn_version}/longhorn-${var.longhorn_version}.tgz"
  namespace        = "longhorn-system"
  create_namespace = true
  wait             = true
}
