# Kubernetes resources

data "http" "cert_manager_crds" {
  url = "https://raw.githubusercontent.com/jetstack/cert-manager/release-${regex("([0-9]+\\.[0-9]+)", var.cert_manager_version)[0]}/deploy/manifests/00-crds.yaml"
}

resource "k8s_manifest" "cert_manager_crds" {
  content = data.http.cert_manager_crds.body
}
