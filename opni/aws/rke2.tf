# RKE2 cluster for Rancher and Opni
resource "ssh_resource" "rke2_config_dir" {
  count = var.opni_cluster_node_count
  host  = aws_instance.opni_server[count.index].public_ip
  commands = [
    "sudo mkdir -p /etc/rancher/rke2",
    "sudo chmod 777 /etc/rancher/rke2"
  ]
  user        = local.node_username
  private_key = tls_private_key.global_key.private_key_pem
}

resource "ssh_resource" "rke2_config_initial" {
  depends_on = [ssh_resource.rke2_config_dir]

  host        = aws_instance.opni_server[0].public_ip
  user        = local.node_username
  private_key = tls_private_key.global_key.private_key_pem

  file {
    content     = <<EOT
tls-san:
  - ${aws_instance.opni_server[0].public_ip}
node-external-ip: ${aws_instance.opni_server[0].public_ip}
node-ip: ${aws_instance.opni_server[0].private_ip}
token: ${var.rke2_token}
EOT
    destination = "/etc/rancher/rke2/config.yaml"
    permissions = "0644"
  }
}

resource "ssh_resource" "rke2_config_others" {
  count      = var.opni_cluster_node_count - 1
  depends_on = [ssh_resource.rke2_config_dir]

  host        = aws_instance.opni_server[count.index + 1].public_ip
  user        = local.node_username
  private_key = tls_private_key.global_key.private_key_pem

  file {
    content     = <<EOT
tls-san:
  - ${aws_instance.opni_server[0].public_ip}
node-external-ip: ${aws_instance.opni_server[count.index + 1].public_ip}
node-ip: ${aws_instance.opni_server[count.index + 1].private_ip}
token: ${var.rke2_token}
server: https://${aws_instance.opni_server[0].public_ip}:9345
EOT
    destination = "/etc/rancher/rke2/config.yaml"
    permissions = "0644"
  }
}

resource "ssh_resource" "install_rke2_0" {
  depends_on = [ssh_resource.rke2_config_initial, ssh_resource.rke2_config_others]
  host       = aws_instance.opni_server[0].public_ip
  commands = [
    "sudo bash -c 'curl https://get.rke2.io | INSTALL_RKE2_VERSION=${var.kubernetes_version} sh -'",
    "sudo systemctl enable rke2-server",
    "sudo systemctl start rke2-server",
  ]
  user        = local.node_username
  private_key = tls_private_key.global_key.private_key_pem
}

resource "ssh_resource" "install_rke2_1" {
  depends_on = [ssh_resource.rke2_config_initial, ssh_resource.rke2_config_others, ssh_resource.install_rke2_0]
  host       = aws_instance.opni_server[1].public_ip
  commands = [
    "sudo bash -c 'curl https://get.rke2.io | INSTALL_RKE2_VERSION=${var.kubernetes_version} sh -'",
    "sudo systemctl enable rke2-server",
    "sudo systemctl start rke2-server",
  ]
  user        = local.node_username
  private_key = tls_private_key.global_key.private_key_pem
}

resource "ssh_resource" "install_rke2_2" {
  depends_on = [ssh_resource.rke2_config_initial, ssh_resource.rke2_config_others, ssh_resource.install_rke2_1]
  host       = aws_instance.opni_server[2].public_ip
  commands = [
    "sudo bash -c 'curl https://get.rke2.io | INSTALL_RKE2_VERSION=${var.kubernetes_version} sh -'",
    "sudo systemctl enable rke2-server",
    "sudo systemctl start rke2-server",
  ]
  user        = local.node_username
  private_key = tls_private_key.global_key.private_key_pem
}

resource "ssh_resource" "check_installation" {
  depends_on = [ssh_resource.install_rke2_2]
  host       = aws_instance.opni_server[0].public_ip
  commands = [
    "sleep 120", # wait until the ingress controller, including the validating webhook is available, otherwise the installation of opni-config with ingresses may fail
    "sudo /var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml rollout status daemonset rke2-ingress-nginx-controller -n kube-system"
  ]
  user        = local.node_username
  private_key = tls_private_key.global_key.private_key_pem
}

resource "ssh_resource" "retrieve_config" {
  depends_on = [
    ssh_resource.check_installation
  ]
  host = aws_instance.opni_server[0].public_ip
  commands = [
    "sudo sed \"s/127.0.0.1/${aws_instance.opni_server[0].public_ip}/g\" /etc/rancher/rke2/rke2.yaml"
  ]
  user        = local.node_username
  private_key = tls_private_key.global_key.private_key_pem
}

# Save kubeconfig file for interacting with the RKE cluster on your local machine
resource "local_file" "kube_config_server_yaml" {
  filename = format("%s/%s", path.root, "kube_config.yaml")
  content  = ssh_resource.retrieve_config.result
}
