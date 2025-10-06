data "azurerm_resource_group" "main" {
  name = "healthcare-app-rg"
}

module "network" {
  source = "../../modules/network"

  resource_group_name = data.azurerm_resource_group.main.name
  location           = data.azurerm_resource_group.main.location
  environment        = var.environment
  project_name       = var.project_name
  tags               = local.tags
}

module "acr" {
  source = "../../modules/acr"

  resource_group_name = data.azurerm_resource_group.main.name
  location           = data.azurerm_resource_group.main.location
  acr_name           = var.acr_name
  sku                = var.acr_sku
  tags               = local.tags
}

module "aks" {
  source = "../../modules/aks"

  resource_group_name = data.azurerm_resource_group.main.name
  location           = data.azurerm_resource_group.main.location
  environment        = var.environment
  project_name       = var.project_name
  node_count         = var.aks_node_count
  vm_size            = var.aks_vm_size
  subnet_id          = module.network.aks_subnet_id
  acr_id             = module.acr.acr_id
  tags               = local.tags
}

locals {
  tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  })
}