# K3s cluster for Rancher

resource "sshcommand_command" "install_k3s" {
  host        = var.node_public_ip
  command     = "bash -c 'curl https://get.k3s.io | INSTALL_K3S_EXEC=\"server --node-external-ip ${var.node_public_ip} --node-ip ${var.node_internal_ip}\" INSTALL_K3S_VERSION=${var.rancher_kubernetes_version} sh -'"
  user        = var.node_username
  private_key = var.ssh_private_key_pem
}

resource "sshcommand_command" "retrieve_config" {
  depends_on = [
    sshcommand_command.install_k3s
  ]
  host        = var.node_public_ip
  command     = "sudo sed \"s/127.0.0.1/${var.node_public_ip}/g\" /etc/rancher/k3s/k3s.yaml"
  user        = var.node_username
  private_key = var.ssh_private_key_pem
}
