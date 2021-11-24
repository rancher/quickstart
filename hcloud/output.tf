
output "rancher_server_url" {
  value = module.rancher_common.rancher_url
}

output "rancher_node_ip" {
  value = hcloud_server.rancher_server.ipv4_address
}

output "workload_node_ip" {
  value = hcloud_server.quickstart_node.ipv4_address
}
