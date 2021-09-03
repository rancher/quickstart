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
  name     = "rg-${var.prefix}-rancher-win"
  location = var.azure_location

  tags = {
    Creator = "rancher-quickstart"
  }
}

# Public IP of Rancher server
resource "azurerm_public_ip" "rancher-server-pip" {
  name                = "pip-rancher-win-server"
  location            = azurerm_resource_group.rancher-quickstart.location
  resource_group_name = azurerm_resource_group.rancher-quickstart.name
  allocation_method   = "Dynamic"

  tags = {
    Creator = "rancher-quickstart"
  }
}

# Azure virtual network space for quickstart resources
resource "azurerm_virtual_network" "rancher-quickstart" {
  name                = "vnet-${var.prefix}-win-demo"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rancher-quickstart.location
  resource_group_name = azurerm_resource_group.rancher-quickstart.name

  tags = {
    Creator = "rancher-quickstart"
  }
}

# Azure internal subnet for quickstart resources
resource "azurerm_subnet" "rancher-quickstart-internal" {
  name                 = "snet-rancher-win-internal"
  resource_group_name  = azurerm_resource_group.rancher-quickstart.name
  virtual_network_name = azurerm_virtual_network.rancher-quickstart.name
  address_prefixes     = ["10.0.0.0/16"]
}

# Azure network interface for quickstart resources
resource "azurerm_network_interface" "rancher-server-interface" {
  name                = "nic-rancher-win"
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
  name                  = "vm-${var.prefix}-rancher-win-plane"
  computer_name         = "${local.computer_name_prefix}-rws" // ensure computer_name meets 15 character limit
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

  rancher_server_dns = join(".", ["rancher", azurerm_linux_virtual_machine.rancher_server.public_ip_address, "nip.io"])

  admin_password = var.rancher_server_admin_password

  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = "azure-custom-ranchdip"

  rke_network_plugin = "flannel"
  rke_network_options = {
    flannel_backend_port = "4789"
    flannel_backend_type = "vxlan"
    flannel_backend_vni  = "4096"
  }
  windows_prefered_cluster = true
}

# Public IP of quickstart node
resource "azurerm_public_ip" "quickstart-node-pip" {
  name                = "pip-win-node"
  location            = azurerm_resource_group.rancher-quickstart.location
  resource_group_name = azurerm_resource_group.rancher-quickstart.name
  allocation_method   = "Dynamic"

  tags = {
    Creator = "rancher-quickstart"
  }
}

# Azure network interface for quickstart resources
resource "azurerm_network_interface" "quickstart-node-interface" {
  name                = "nic-win-node"
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

# Azure linux virtual machine for creating for the workload cluster
resource "azurerm_linux_virtual_machine" "quickstart-node" {
  name                  = "vm-${var.prefix}-win-node-master"
  computer_name         = "${local.computer_name_prefix}-qm" // ensure computer_name meets 15 character limit
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

# Public IP of quickstart node
resource "azurerm_public_ip" "quickstart-windows-node-pip" {
  name                = "pip-windows-node"
  location            = azurerm_resource_group.rancher-quickstart.location
  resource_group_name = azurerm_resource_group.rancher-quickstart.name
  allocation_method   = "Dynamic"

  tags = {
    Creator = "rancher-quickstart"
  }
}

# Azure network interface for quickstart resources
resource "azurerm_network_interface" "quickstart-windows-node-interface" {
  name                = "nic-windows-node"
  location            = azurerm_resource_group.rancher-quickstart.location
  resource_group_name = azurerm_resource_group.rancher-quickstart.name

  ip_configuration {
    name                          = "rancher_server_ip_config"
    subnet_id                     = azurerm_subnet.rancher-quickstart-internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.quickstart-windows-node-pip.id
  }

  tags = {
    Creator = "rancher-quickstart"
  }
}

# Azure windows virtual machine for joining the workload cluster
resource "azurerm_windows_virtual_machine" "quickstart-windows-node" {
  name                  = "vm-${var.prefix}-win-node-worker"
  computer_name         = "${local.computer_name_prefix}-qw" // ensure computer_name meets 15 character limit
  location              = azurerm_resource_group.rancher-quickstart.location
  resource_group_name   = azurerm_resource_group.rancher-quickstart.name
  network_interface_ids = [azurerm_network_interface.quickstart-windows-node-interface.id]
  size                  = var.instance_type
  admin_username        = "adminuser"
  admin_password        = var.windows_admin_password

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-with-Containers"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = {
    Creator = "rancher-quickstart"
  }
}

# Join windows not to the cluster
resource "azurerm_virtual_machine_extension" "join-rancher" {
  name                 = "cse-${var.prefix}-windows-node-join-rancher"
  virtual_machine_id   = azurerm_windows_virtual_machine.quickstart-windows-node.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": ${jsonencode(
  replace(
    module.rancher_common.custom_cluster_windows_command,
    "| iex}",
    "--address ${azurerm_windows_virtual_machine.quickstart-windows-node.public_ip_address} --internal-address ${azurerm_windows_virtual_machine.quickstart-windows-node.private_ip_address} --worker | iex}",
  )
)}
    }
SETTINGS
}




#Get TC remote backend working or change to local state for faster plans/applies.
#Local execution against remote TC back-end is too slow