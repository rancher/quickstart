output "opni_url" {
  value = local.opni_hostname
}

output "rancher_url" {
  value = local.rancher_hostname
}

output "grafana_url" {
  value = local.grafana_hostname
}

output "opensearch_url" {
  value = local.opensearch_hostname
}

output "opniadmin_url" {
  value = local.opniadmin_hostname
}

output "node_ips" {
  value = aws_instance.opni_server[*].public_ip
}
