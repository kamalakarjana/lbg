terraform {
  backend "azurerm" {
    resource_group_name  = "healthcare-app-rg"
    storage_account_name = "tfstatestorageacc160689"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}