output "rancher-url" {
  value = ["https://${vsphere_virtual_machine.server.default_ip_address}"]
}