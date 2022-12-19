
output "rancher_server_url" {
  value = module.rancher_common.rancher_url
}

output "rancher_node_ip" {
  value = harvester_virtualmachine.rancher_server.network_interface[0].ip_address
}

# output "workload_node_ip" {
#   value = harvester_virtualmachine.quickstart_node.network_interface[0].ip_address
# }
