# backend.tf or in your main.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg-dev"
    storage_account_name = "tfstatestorageacc9000dev"
    container_name       = "tfstate-dev"
    key                  = "healthcare-app-dev.tfstate"
  }

  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}
