# Provider configuration
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  } 
}

provider "azurerm" {
  features {}
}


data "azurerm_resource_group" "rsg_ia" {
    name = "rg-altice-chatgoc-dev"
}

resource "azurerm_storage_account" "default" {
  name                            = "teste-iac-action"
  location                        = data.azurerm_resource_group.rsg_ia.location
  resource_group_name             = data.azurerm_resource_group.rsg_ia.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
}