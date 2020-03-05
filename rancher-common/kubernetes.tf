# Kubernetes resources

# Create cert-manager-crd service account
resource "kubernetes_service_account" "cert_manager_crd" {
  depends_on = [rke_cluster.rancher_cluster]

  metadata {
    name      = "cert-manager-crd"
    namespace = "kube-system"
  }

  automount_service_account_token = true
}

# Bind cert-manager-crd service account to cluster-admin
resource "kubernetes_cluster_role_binding" "cert_manager_crd_admin" {
  depends_on = [rke_cluster.rancher_cluster]

  metadata {
    name = "${kubernetes_service_account.cert_manager_crd.metadata[0].name}-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cert_manager_crd.metadata[0].name
    namespace = "kube-system"
  }
}

locals {
  # split_rke_kubernetes_version
  srkv          = split("-", var.rke_kubernetes_version)
  hyperkube_tag = join("-", [local.srkv[0], local.srkv[1]])
}

# Create cert-manager namespace
resource "kubernetes_job" "create_cert_manager_ns" {
  metadata {
    name      = "create-cert-manager-ns"
    namespace = "kube-system"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "hyperkube"
          image   = "rancher/hyperkube:${local.hyperkube_tag}"
          command = ["kubectl", "create", "namespace", "cert-manager"]
        }
        host_network                    = true
        automount_service_account_token = true
        service_account_name            = kubernetes_service_account.cert_manager_crd.metadata[0].name
        restart_policy                  = "Never"
      }
    }
  }
}

# Create and run job to install cert-manager CRDs
resource "kubernetes_job" "install_certmanager_crds" {
  metadata {
    name      = "install-certmanager-crds"
    namespace = "kube-system"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "hyperkube"
          image   = "rancher/hyperkube:${local.hyperkube_tag}"
          command = ["kubectl", "apply", "-f", "https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml", "--validate=false"]
        }
        host_network                    = true
        automount_service_account_token = true
        service_account_name            = kubernetes_service_account.cert_manager_crd.metadata[0].name
        restart_policy                  = "Never"
      }
    }
  }
}

# Create cattle-system namespace for Rancher
resource "kubernetes_job" "create_cattle_system_ns" {
  metadata {
    name      = "create-cattle-system-ns"
    namespace = "kube-system"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "hyperkube"
          image   = "rancher/hyperkube:${local.hyperkube_tag}"
          command = ["kubectl", "create", "namespace", "cattle-system"]
        }
        host_network                    = true
        automount_service_account_token = true
        service_account_name            = kubernetes_service_account.cert_manager_crd.metadata[0].name
        restart_policy                  = "Never"
      }
    }
  }
}
