output "rancher_server_url" {
  value = module.rancher_common.rancher_url
}

output "rancher_node_ip" {
  value = linode_instance.rancher_server.ip_address
}

output "workload_node_ip" {
  value = linode_instance.quickstart_node.ip_address
}
