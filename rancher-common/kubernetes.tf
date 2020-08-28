# Kubernetes resources

locals {
  cert_manager_crds_content  = file(join("/", [path.module, "files/cert-manager/crds-${var.cert_manager_version}.yaml"]))
  cert_manager_crds_sections = split("---", local.cert_manager_crds_content)
}

resource "k8s_manifest" "cert_manager_crds" {
  count   = length(local.cert_manager_crds_sections)
  content = local.cert_manager_crds_sections[count.index]
}
