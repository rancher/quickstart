output "rancher_server_url" {
  value = module.rancher_common.rancher_url
}

output "rancher_node_ip" {
  value = azurerm_linux_virtual_machine.rancher_server.public_ip_address
}

output "workload_node_ip" {
  value = azurerm_linux_virtual_machine.quickstart-node.public_ip_address
}
