# Terraform configuration for Burger Builder Infrastructure

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = var.tf_state_rg
    storage_account_name = var.tf_state_storage
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
