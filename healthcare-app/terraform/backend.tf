terraform {
  backend "azurerm" {
    resource_group_name  = "rg-healthapp01"
    storage_account_name = "sthealthapp01"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
