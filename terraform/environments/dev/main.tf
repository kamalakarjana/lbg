provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}

# Create the resource group first
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "network" {
  source                = "../../modules/network"
  resource_group_name   = azurerm_resource_group.main.name
  location              = var.location
  environment           = var.environment
  project_name          = var.project_name
  vnet_address_space    = ["10.0.0.0/16"]
  subnet_address_prefix = "10.0.1.0/24"
  tags                  = var.tags

  depends_on = [azurerm_resource_group.main]
}

module "acr" {
  source               = "../../modules/acr"
  acr_name             = var.acr_name
  location             = var.location
  resource_group_name  = azurerm_resource_group.main.name
  sku                  = var.acr_sku
  tags                 = var.tags

  depends_on = [azurerm_resource_group.main]
}

module "aks" {
  source              = "../../modules/aks"
  cluster_name        = var.aks_cluster_name    # Only this line changed
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  environment         = var.environment
  dns_prefix          = "${var.project_name}-k8s-${var.environment}"
  node_count          = var.node_count          # Only this line changed
  vm_size             = var.vm_size             # Only this line changed
  kubernetes_version  = var.kubernetes_version
  subnet_id           = module.network.aks_subnet_id
  acr_id              = module.acr.acr_id
  tags                = var.tags

  depends_on = [
    azurerm_resource_group.main,
    module.network,
    module.acr
  ]
}