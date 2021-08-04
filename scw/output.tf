
output "rancher_server_url" {
  value = module.rancher_common.rancher_url
}

output "rancher_node_ip" {
  value = scaleway_instance_server.rancher_server.public_ip
}

output "workload_node_ip" {
  value = scaleway_instance_server.quickstart_node.public_ip
}
