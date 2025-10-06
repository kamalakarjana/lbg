# Provider configuration for the environment
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Get current client configuration
data "azurerm_client_config" "current" {}

module "network" {
  source = "../../modules/network"

  resource_group_name = var.resource_group_name
  location            = var.location
  environment         = var.environment
  project_name        = var.project_name
  tags                = var.tags
}

module "acr" {
  source = "../../modules/acr"

  resource_group_name = var.resource_group_name
  location            = var.location
  acr_name            = var.acr_name
  sku                 = var.acr_sku
  tags                = var.tags
}

module "aks" {
  source = "../../modules/aks"

  resource_group_name     = var.resource_group_name
  location                = var.location
  environment             = var.environment
  project_name            = var.project_name
  node_count              = var.aks_node_count
  vm_size                 = var.aks_vm_size
  kubernetes_version      = var.kubernetes_version
  subnet_id               = module.network.aks_subnet_id
  acr_id                  = module.acr.acr_id
  tags                    = var.tags

  depends_on = [module.network, module.acr]
}