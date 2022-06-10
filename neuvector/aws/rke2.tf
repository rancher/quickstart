# RKE2 cluster for NeuVector
resource "ssh_resource" "rke2_config_dir" {
  host = aws_instance.neuvector_server.public_ip
  commands = [
    "sudo mkdir -p /etc/rancher/rke2",
    "sudo chmod 777 /etc/rancher/rke2"
  ]
  user        = local.node_username
  private_key = tls_private_key.global_key.private_key_pem
}
resource "ssh_resource" "rke2_config" {
  depends_on = [ssh_resource.rke2_config_dir]

  host        = aws_instance.neuvector_server.public_ip
  user        = local.node_username
  private_key = tls_private_key.global_key.private_key_pem

  file {
    content     = <<EOT
tls-san:
  - ${aws_instance.neuvector_server.public_ip}
node-external-ip: ${aws_instance.neuvector_server.public_ip}
node-ip: ${aws_instance.neuvector_server.private_ip}
EOT
    destination = "/etc/rancher/rke2/config.yaml"
    permissions = "0644"
  }
}
resource "ssh_resource" "install_rke2" {
  depends_on = [ssh_resource.rke2_config]
  host       = aws_instance.neuvector_server.public_ip
  commands = [
    "sudo bash -c 'curl https://get.rke2.io | INSTALL_RKE2_VERSION=${var.kubernetes_version} sh -'",
    "sudo systemctl enable rke2-server",
    "sudo systemctl start rke2-server",
    "sleep 120", # wait until the ingress controller, including the validating webhook is available, otherwise the installation of charts with ingresses may fail
    "sudo /var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml rollout status daemonset rke2-ingress-nginx-controller -n kube-system"
  ]
  user        = local.node_username
  private_key = tls_private_key.global_key.private_key_pem
}

resource "ssh_resource" "retrieve_config" {
  depends_on = [
    ssh_resource.install_rke2
  ]
  host = aws_instance.neuvector_server.public_ip
  commands = [
    "sudo sed \"s/127.0.0.1/${aws_instance.neuvector_server.public_ip}/g\" /etc/rancher/rke2/rke2.yaml"
  ]
  user        = local.node_username
  private_key = tls_private_key.global_key.private_key_pem
}

# Save kubeconfig file for interacting with the RKE cluster on your local machine
resource "local_file" "kube_config_server_yaml" {
  filename = format("%s/%s", path.root, "kube_config.yaml")
  content  = ssh_resource.retrieve_config.result
}
