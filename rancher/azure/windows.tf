# Public IP of quickstart node
resource "azurerm_public_ip" "quickstart-windows-node-pip" {
  count = var.add_windows_node ? 1 : 0

  name                = "quickstart-windows-node-pip"
  location            = azurerm_resource_group.rancher-quickstart.location
  resource_group_name = azurerm_resource_group.rancher-quickstart.name
  allocation_method   = "Dynamic"

  tags = {
    Creator = "rancher-quickstart"
  }
}

# Azure network interface for quickstart resources
resource "azurerm_network_interface" "quickstart-windows-node-interface" {
  count = var.add_windows_node ? 1 : 0

  name                = "quickstart-windows-node-interface"
  location            = azurerm_resource_group.rancher-quickstart.location
  resource_group_name = azurerm_resource_group.rancher-quickstart.name

  ip_configuration {
    name                          = "rancher_server_ip_config"
    subnet_id                     = azurerm_subnet.rancher-quickstart-internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.quickstart-windows-node-pip[count.index].id
  }

  tags = {
    Creator = "rancher-quickstart"
  }
}

# Azure windows virtual machine for joining the workload cluster
resource "azurerm_windows_virtual_machine" "quickstart-windows-node" {
  count = var.add_windows_node ? 1 : 0

  name                  = "${var.prefix}-quickstart-win-node-worker"
  computer_name         = "${local.computer_name_prefix}-qw" // ensure computer_name meets 15 character limit
  location              = azurerm_resource_group.rancher-quickstart.location
  resource_group_name   = azurerm_resource_group.rancher-quickstart.name
  network_interface_ids = [azurerm_network_interface.quickstart-windows-node-interface[count.index].id]
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
  count = var.add_windows_node ? 1 : 0

  name                 = "${var.prefix}-quickstart-windows-node-join-rancher"
  virtual_machine_id   = azurerm_windows_virtual_machine.quickstart-windows-node[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": ${jsonencode(templatefile(
  "${path.module}/files/userdata_quickstart_windows.template",
  {
    register_command   = module.rancher_common.custom_cluster_windows_command
    public_ip_address  = azurerm_windows_virtual_machine.quickstart-windows-node[count.index].public_ip_address
    private_ip_address = azurerm_windows_virtual_machine.quickstart-windows-node[count.index].private_ip_address
  }
))}
    }
SETTINGS
}

output "windows-workload-ips" {
  value = azurerm_windows_virtual_machine.quickstart-windows-node[*].public_ip_address
}