output "rancher_server_url" {
  value = module.rancher_common.rancher_url
}

output "rancher_node_ip" {
  value = outscale_vm.rancher_server.public_ip
}

output "workload_node_ip" {
  value = outscale_vm.quickstart_node.public_ip
}
