# Generate a short-lived SSH key for the provisioner to access the nodes.
# The key is removed from the nodes during provisioning.
resource "tls_private_key" "provisioning_key" {
  algorithm   = "RSA"
}
