output "rancher-url" {
  value = ["https://${opentelekomcloud_networking_floatingip_v2.eip_1.address}"]
}
