# Example resource group (replace or extend as needed)
resource "azurerm_resource_group" "main" {
  name     = var.tf_state_rg
  location = "East US" # Change as needed
}

# Example storage account for remote state (replace or extend as needed)
resource "azurerm_storage_account" "tfstate" {
  name                     = var.tf_state_storage
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = false
}
