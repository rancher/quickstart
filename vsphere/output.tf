output "rancher_server_url" {
  value = module.rancher_common.rancher_url
}

output "rancher_node_ips" {
  value = vsphere_virtual_machine.rke[*].default_ip_address
}