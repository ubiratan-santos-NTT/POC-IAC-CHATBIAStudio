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
  name                            = "${var.prefix}storage${random_string.suffix.result}"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  allow_nested_items_to_be_public = false
}