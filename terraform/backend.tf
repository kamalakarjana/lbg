terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg-dev"
    storage_account_name = "tfstatestorageacc9000dev"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}