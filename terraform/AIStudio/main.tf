resource "random_pet" "rg_name" { 
  prefix = var.resource_group_name_prefix
}

// RESOURCE GROUP
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

module "keyvault" {
  source    = "./key-vault"
  
  tenant_id = "tenant_id"
  sku_name  = "standard"
  prefix    = "IA-Altice" 
}


module "storageaccount" {
    source    = "./storage-account"
  
    prefix    = "IA-Altice" 
}

module "IAStudio" {
    source = "./AIServices"
    sku = "SK0"      
}