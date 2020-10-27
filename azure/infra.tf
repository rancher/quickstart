# Azure Infrastructure Resources

resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "ssh_private_key_pem" {
  filename          = "${path.module}/id_rsa"
  sensitive_content = tls_private_key.global_key.private_key_pem
  file_permission   = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${path.module}/id_rsa.pub"
  content  = tls_private_key.global_key.public_key_openssh
}

# Resource group containing all resources
resource "azurerm_resource_group" "rancher-quickstart" {
  name     = "${var.prefix}-rancher-quickstart"
  location = var.azure_location

  tags = {
    Creator = "rancher-quickstart"
  }
}

# Public IP of Rancher server
resource "azurerm_public_ip" "rancher-server-pip" {
  name                = "rancher-server-pip"
  location            = azurerm_resource_group.rancher-quickstart.location
  resource_group_name = azurerm_resource_group.rancher-quickstart.name
  allocation_method   = "Dynamic"

  tags = {
    Creator = "rancher-quickstart"
  }
}

# Azure virtual network space for quickstart resources
resource "azurerm_virtual_network" "rancher-quickstart" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rancher-quickstart.location
  resource_group_name = azurerm_resource_group.rancher-quickstart.name

  tags = {
    Creator = "rancher-quickstart"
  }
}

# Azure internal subnet for quickstart resources
resource "azurerm_subnet" "rancher-quickstart-internal" {
  name                 = "rancher-quickstart-internal"
  resource_group_name  = azurerm_resource_group.rancher-quickstart.name
  virtual_network_name = azurerm_virtual_network.rancher-quickstart.name
  address_prefixes     = ["10.0.0.0/16"]
}

# Azure network interface for quickstart resources
resource "azurerm_network_interface" "rancher-server-interface" {
  name                = "rancher-quickstart-interface"
  location            = azurerm_resource_group.rancher-quickstart.location
  resource_group_name = azurerm_resource_group.rancher-quickstart.name

  ip_configuration {
    name                          = "rancher_server_ip_config"
    subnet_id                     = azurerm_subnet.rancher-quickstart-internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rancher-server-pip.id
  }

  tags = {
    Creator = "rancher-quickstart"
  }
}

// ensure computer_name meets 15 character limit
// uses assumption that resources only use 4 characters for a suffix
locals {
  computer_name_prefix = substr(var.prefix, 0, 11)
}

# Azure linux virtual machine for creating a single node RKE cluster and installing the Rancher Server
resource "azurerm_linux_virtual_machine" "rancher_server" {
  name                  = "${var.prefix}-rancher-server"
  computer_name         = "${local.computer_name_prefix}-rs" // ensure computer_name meets 15 character limit
  location              = azurerm_resource_group.rancher-quickstart.location
  resource_group_name   = azurerm_resource_group.rancher-quickstart.name
  network_interface_ids = [azurerm_network_interface.rancher-server-interface.id]
  size                  = var.instance_type
  admin_username        = local.node_username

  custom_data = base64encode(
    templatefile(
      join("/", [path.module, "../cloud-common/files/userdata_rancher_server.template"]),
      {
        docker_version = var.docker_version
        username       = local.node_username
      }
    )
  )

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = local.node_username
    public_key = tls_private_key.global_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = {
    Creator = "rancher-quickstart"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip_address
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
}

# Rancher resources
module "rancher_common" {
  source = "../rancher-common"

  node_public_ip         = azurerm_linux_virtual_machine.rancher_server.public_ip_address
  node_internal_ip       = azurerm_linux_virtual_machine.rancher_server.private_ip_address
  node_username          = local.node_username
  ssh_private_key_pem    = tls_private_key.global_key.private_key_pem
  rke_kubernetes_version = var.rke_kubernetes_version

  cert_manager_version = var.cert_manager_version
  rancher_version      = var.rancher_version

  rancher_server_dns = join(".", ["rancher", azurerm_linux_virtual_machine.rancher_server.public_ip_address, "xip.io"])

  admin_password = var.rancher_server_admin_password

  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = "quickstart-azure-custom"
}

# Public IP of quickstart node
resource "azurerm_public_ip" "quickstart-node-pip" {
  name                = "quickstart-node-pip"
  location            = azurerm_resource_group.rancher-quickstart.location
  resource_group_name = azurerm_resource_group.rancher-quickstart.name
  allocation_method   = "Dynamic"

  tags = {
    Creator = "rancher-quickstart"
  }
}

# Azure network interface for quickstart resources
resource "azurerm_network_interface" "quickstart-node-interface" {
  name                = "quickstart-node-interface"
  location            = azurerm_resource_group.rancher-quickstart.location
  resource_group_name = azurerm_resource_group.rancher-quickstart.name

  ip_configuration {
    name                          = "rancher_server_ip_config"
    subnet_id                     = azurerm_subnet.rancher-quickstart-internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.quickstart-node-pip.id
  }

  tags = {
    Creator = "rancher-quickstart"
  }
}

# Azure linux virtual machine for creating a single node RKE cluster and installing the Rancher Server
resource "azurerm_linux_virtual_machine" "quickstart-node" {
  name                  = "${var.prefix}-quickstart-node"
  computer_name         = "${local.computer_name_prefix}-qn" // ensure computer_name meets 15 character limit
  location              = azurerm_resource_group.rancher-quickstart.location
  resource_group_name   = azurerm_resource_group.rancher-quickstart.name
  network_interface_ids = [azurerm_network_interface.quickstart-node-interface.id]
  size                  = var.instance_type
  admin_username        = local.node_username

  custom_data = base64encode(
    templatefile(
      join("/", [path.module, "files/userdata_quickstart_node.template"]),
      {
        docker_version   = var.docker_version
        username         = local.node_username
        register_command = module.rancher_common.custom_cluster_command
      }
    )
  )

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = local.node_username
    public_key = tls_private_key.global_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = {
    Creator = "rancher-quickstart"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip_address
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
}
