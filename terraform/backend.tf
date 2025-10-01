terraform {
  required_version = ">= 1.0.0"

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestorageacc9000"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    # Optional: use environment variables for security in CI
    # subscription_id      = var.subscription_id
    # tenant_id            = var.tenant_id
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

