# Data for rancher common module

# Helm data
# ----------------------------------------------------------

# Jetstack Helm repository
data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

# Rancher Helm repository
data "helm_repository" "rancher_stable" {
  name = "rancher-stable"
  url  = "https://releases.rancher.com/server-charts/stable"
}

data "helm_repository" "rancher_latest" {
  name = "rancher-latest"
  url  = "https://releases.rancher.com/server-charts/latest"
}

# Kubernetes data
# ----------------------------------------------------------

# # Rancher certificates
# data "kubernetes_secret" "rancher_cert" {
#   depends_on = [helm_release.rancher_server]

#   metadata {
#     name      = "tls-rancher-ingress"
#     namespace = "cattle-system"
#   }
# }
