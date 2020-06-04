# GCP infrastructure resources

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
    ssh-keys = "ubuntu:${file("${var.ssh_key_file_name}.pub")}"
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
      private_key = file(var.ssh_key_file_name)
    }
  }
}

# Rancher resources
module "rancher_common" {
  source = "../rancher-common"

  node_public_ip         = google_compute_instance.rancher_server.network_interface.0.access_config.0.nat_ip
  node_internal_ip       = google_compute_instance.rancher_server.network_interface.0.network_ip
  node_username          = local.node_username
  ssh_key_file_name      = var.ssh_key_file_name
  rke_kubernetes_version = var.rke_kubernetes_version

  cert_manager_version = var.cert_manager_version
  rancher_version      = var.rancher_version

  rancher_server_dns = "${replace(google_compute_instance.rancher_server.network_interface.0.access_config.0.nat_ip, ".", "-")}.nip.io"
  admin_password     = var.rancher_server_admin_password

  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = "quickstart-gcp-custom"
}

# GCP compute instance for creating a single node workload cluster
resource "google_compute_instance" "quickstart_node" {
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
    ssh-keys = "ubuntu:${file("${var.ssh_key_file_name}.pub")}"
    user-data = templatefile(
      join("/", [path.module, "../cloud-common/files/userdata_quickstart_node.template"]),
      {
        docker_version   = var.docker_version
        username         = local.node_username
        register_command = module.rancher_common.custom_cluster_command
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
      private_key = file(var.ssh_key_file_name)
    }
  }
}
