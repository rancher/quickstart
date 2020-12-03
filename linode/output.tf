output "rancher_server_url" {
  value = module.rancher_common.rancher_url
}

output "rancher_node_ips" {
  value = linode_instance.rke[*].ip_address
}