output "neuvector_url" {
  value = local.neuvector_hostname
}

output "rancher_url" {
  value = var.install_rancher ? local.rancher_hostname : null
}

output "node_ip" {
  value = aws_instance.neuvector_server.public_ip
}
