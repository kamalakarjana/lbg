# Generate random suffix for unique resource names
resource "random_id" "suffix" {
  byte_length = 4
}

# Configure Azure Provider
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}


# Create the main resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Network Module
module "network" {
  source = "../../modules/network"

  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  environment           = var.environment
  project_name          = var.project_name
  vnet_address_space    = var.vnet_address_space
  subnet_address_prefix = var.subnet_address_prefix
  tags                  = local.common_tags

  depends_on = [azurerm_resource_group.main]
}

# Azure Container Registry Module
module "acr" {
  source = "../../modules/acr"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  acr_name            = "${var.acr_name}${random_id.suffix.hex}"
  sku                 = var.acr_sku
  tags                = local.common_tags

  depends_on = [azurerm_resource_group.main]
}

# Azure Kubernetes Service Module
module "aks" {
  source = "../../modules/aks"

  cluster_name        = var.aks_cluster_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  dns_prefix          = "${var.project_name}-k8s-${var.environment}"
  node_count          = var.node_count
  vm_size             = var.vm_size
  kubernetes_version  = var.kubernetes_version
  subnet_id           = module.network.aks_subnet_id
  acr_id              = module.acr.acr_id
  tags                = local.common_tags

  depends_on = [
    azurerm_resource_group.main,
    module.network,
    module.acr
  ]
}

# Common tags for all resources
locals {
  common_tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
    Repository  = "healthcare-app"
  })
}
