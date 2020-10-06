# Kubernetes resources

locals {
  cert_manager_crds_content  = file(join("/", [path.module, "files/cert-manager/crds-${var.cert_manager_version}.yaml"]))
  cert_manager_crds_sections = split("---", local.cert_manager_crds_content)
}

resource "k8s_manifest" "cert_manager_crds" {
  count   = var.ingress_tls_source != "secret" ? length(local.cert_manager_crds_sections): 0
  content = local.cert_manager_crds_sections[count.index]
}

resource "kubernetes_namespace" "cattle-system" {
  count   = var.ingress_tls_source == "secret" ? 1 : 0
  depends_on = [
    rke_cluster.rancher_cluster,
  ]
  metadata {
    name = "cattle-system"
    # Need to create these dummy annotations to make ignore_changes work
    annotations = {
      "cattle.io/status" = "",
      "field.cattle.io/projectId" = "",
      "lifecycle.cattle.io/create.namespace-auth" = ""
    }
    # Need to create these dummy labels to make ignore_changes work
    labels = {
      "field.cattle.io/projectId" = ""
    }
  }
  lifecycle {
    ignore_changes = [
      metadata.0.annotations["cattle.io/status"],
      metadata.0.annotations["lifecycle.cattle.io/create.namespace-auth"],
      metadata.0.annotations["field.cattle.io/projectId"],
      metadata.0.labels["field.cattle.io/projectId"]
    ]
  }
}

resource "kubernetes_secret" "tls-rancher-ingress" {
  count   = var.ingress_tls_source == "secret" ? 1 : 0
  depends_on = [
    kubernetes_namespace.cattle-system,
  ]
  metadata {
    name      = "tls-rancher-ingress"
    namespace = "cattle-system"
    annotations = {
      "field.cattle.io/projectId" = ""
    }
  }
  data = {
    "tls.crt" = file(var.server_certificate)
    "tls.key" = file(var.server_certificate_key)
  }
  lifecycle {
    ignore_changes = [
      metadata.0.annotations["field.cattle.io/projectId"]
    ]
  }
}

resource "kubernetes_secret" "tls-ca" {
  count = var.use_private_ca ? 1 : 0
  depends_on = [
    kubernetes_namespace.cattle-system,
  ]
  metadata {
    name      = "tls-ca"
    namespace = "cattle-system"
    # Need to create these dummy annotations to make ignore_changes work
    annotations = {
      "field.cattle.io/projectId" = ""
    }
  }
  data = {
    "cacerts.pem" = file(var.server_private_ca_certificate)
  }
  lifecycle {
    ignore_changes = [
      metadata.0.annotations["field.cattle.io/projectId"]
    ]
  }
}

resource "kubernetes_secret" "helm_image_pull_secret" {
  count   = var.ingress_tls_source == "secret" ? 1 : 0
  depends_on = [
    kubernetes_namespace.cattle-system,
  ]
  metadata {
    name      = local.rancher_image_registry_secret_name
    namespace = "cattle-system"
    # Need to create these dummy annotations to make ignore_changes work
    annotations = {
      "field.cattle.io/projectId" = ""
    }
  }
  type = "Opaque"
  data = {
      "username" = var.rancher_image_registry_username
      "password" = var.rancher_image_registry_password
  }
  lifecycle {
    ignore_changes = [
      metadata.0.annotations["field.cattle.io/projectId"]
    ]
  }
}
