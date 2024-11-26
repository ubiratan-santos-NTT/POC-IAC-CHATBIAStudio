# Provider configuration
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    key = "dev.terraform.tfstate"
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

  name                  = "iac-iastudiohub-github-runner-logs"
  sku                   = "PerGB2018"
  retention_in_days     = 7
}



resource "azurerm_container_app_environment" "container_app_environment" {
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rsg_ia.location

  name                          = "iac-iastudiohub-github-runner-appenv"

  log_analytics_workspace_id    = azurerm_log_analytics_workspace.log_analytics_workspace.id
}



resource "azurerm_container_app" "container_app" {
  resource_group_name = azurerm_resource_group.rg.name

  name                          = "iac-iastudiohub-github-runner-logs"
  container_app_environment_id  = azurerm_container_app_environment.container_app_environment.id
  location                      = data.azurerm_resource_group.rsg_ia.location
  revision_mode                 = "Single"  

  template {
    container {
      name   = "github-runner"
      image  = "myoung34/github-runner:latest"
      cpu    = 1
      memory = "2Gi"

        env {
            name  = "GITHUB_TOKEN"
            value = var.github_token
        }
    }
  }
}