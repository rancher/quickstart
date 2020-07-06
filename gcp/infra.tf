# GCP infrastructure resources

resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "ssh_private_key_pem" {
  filename          = "${path.module}/id_rsa"
  sensitive_content = tls_private_key.global_key.private_key_pem
  file_permission   = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${path.module}/id_rsa.pub"
  content  = tls_private_key.global_key.public_key_openssh
}

# GCP Public Compute Address for rancher server node
resource "google_compute_address" "rancher_server_address" {
  name = "rancher-server-ipv4-address"
}

# GCP Public Compute Address for quickstart node
resource "google_compute_address" "quickstart_node_address" {
  name = "quickstart-node-ipv4-address"
}

# Firewall Rule to allow all traffic
resource "google_compute_firewall" "rancher_fw_allowall" {
  name    = "${var.prefix}-rancher-allowall"
  network = "default"

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

# GCP Compute Instance for creating a single node RKE cluster and installing the Rancher server
resource "google_compute_instance" "rancher_server" {
  depends_on = [
    google_compute_firewall.rancher_fw_allowall,
  ]

  name         = "${var.prefix}-rancher-server"
  machine_type = var.machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.rancher_server_address.address
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${tls_private_key.global_key.public_key_openssh}"
    user-data = templatefile(
      join("/", [path.module, "../cloud-common/files/userdata_rancher_server.template"]),
      {
        docker_version = var.docker_version
        username       = local.node_username
      }
    )
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.network_interface.0.access_config.0.nat_ip
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
}

# Rancher resources
module "rancher_common" {
  source = "../rancher-common"

  node_public_ip         = google_compute_instance.rancher_server.network_interface.0.access_config.0.nat_ip
  node_internal_ip       = google_compute_instance.rancher_server.network_interface.0.network_ip
  node_username          = local.node_username
  ssh_private_key_pem    = tls_private_key.global_key.private_key_pem
  rke_kubernetes_version = var.rke_kubernetes_version

  cert_manager_version = var.cert_manager_version
  rancher_version      = var.rancher_version

  rancher_server_dns = join(".", ["rancher", google_compute_instance.rancher_server.network_interface.0.access_config.0.nat_ip, "xip.io"])
  admin_password     = var.rancher_server_admin_password

  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = "quickstart-gcp-custom"
}

# GCP compute instance for creating a single node workload cluster
resource "google_compute_instance" "quickstart_node" {
  depends_on = [
    google_compute_firewall.rancher_fw_allowall,
  ]

  name         = "${var.prefix}-quickstart-node"
  machine_type = var.machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.quickstart_node_address.address
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${tls_private_key.global_key.public_key_openssh}"
    user-data = templatefile(
      join("/", [path.module, "files/userdata_quickstart_node.template"]),
      {
        docker_version   = var.docker_version
        username         = local.node_username
        register_command = module.rancher_common.custom_cluster_command
        public_ip        = google_compute_address.quickstart_node_address.address
      }
    )
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.network_interface.0.access_config.0.nat_ip
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
}
