resource "azurerm_linux_virtual_machine" "sonarqube" {
  name                = "burger-builder-sonarqube"
  resource_group_name = local.rg_name
  location            = local.location
  size                = "Standard_D2s_v3"
  zone                = "2"
  admin_username      = "sonarqubeadmin"
  network_interface_ids = [azurerm_network_interface.sonarqube.id]
  admin_password      = var.sonarqube_vm_password
  disable_password_authentication = false
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "sonarqubeosdisk"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "sonarqube" {
  name                = "sonarqube-nic"
  location            = local.location
  resource_group_name = local.rg_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sonarqube.id
  }
}
