terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg-dev"
    storage_account_name = "tfstatestorageacc9000dev"
    container_name       = "tfstate-dev"
    key                  = "healthcare-app-dev.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

# Configure the Azure Provider - Authentication via environment variables only
provider "azurerm" {
  features {}
  # No explicit credentials - they come from ARM_CLIENT_ID, ARM_CLIENT_SECRET, etc.
}