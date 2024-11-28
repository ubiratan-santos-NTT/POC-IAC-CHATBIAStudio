# Provider configuration
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name   = "rg-altice-chatgoc-dev"
    storage_account_name  = "iacpocstateiastudio"
    container_name        = var.container_name
    key                   = "key=dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}


data "azurerm_resource_group" "rsg_ia" {
    name = "rg-altice-chatgoc-dev"
}

#Log Analitics
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  resource_group_name   = data.azurerm_resource_group.rsg_ia.name
  location              = data.azurerm_resource_group.rsg_ia.location

  name                  = "iac-iastudiohub-runner-logs"
  sku                   = "PerGB2018"
  retention_in_days     = 30
}



resource "azurerm_container_app_environment" "container_app_environment" {
  resource_group_name           = data.azurerm_resource_group.rsg_ia.name
  location                      = data.azurerm_resource_group.rsg_ia.location

  name                          = "iac-iastudiohub-runner-appenv"

  log_analytics_workspace_id    = azurerm_log_analytics_workspace.log_analytics_workspace.id
}



resource "azurerm_container_app" "container_app" {
  resource_group_name = data.azurerm_resource_group.rsg_ia.name

  name                          = "iac-iastudiohub-runner-logs"
  container_app_environment_id  = azurerm_container_app_environment.container_app_environment.id
  revision_mode                 = "Single"  

  template {
    container {
      name   = "github-runner"
      image  = "myoung34/github-runner:latest"
      cpu    = 1
      memory = "2Gi"

        env {
            name  = "ACCESS_TOKEN"
            value = var.github_token
        }
    }
  }
}