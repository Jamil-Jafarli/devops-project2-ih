resource "azurerm_public_ip" "sonarqube" {
  name                = "sonarqube-public-ip"
  location            = local.location
  resource_group_name = local.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}
