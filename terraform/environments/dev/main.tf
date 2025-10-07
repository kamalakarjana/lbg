provider "azurerm" {
  features {}
}

module "network" {
  source              = "../../modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = "${var.project_name}-vnet"
  subnet_name         = "${var.project_name}-subnet"
  address_space       = "10.0.0.0/16"
  subnet_prefix       = "10.0.1.0/24"
}

module "acr" {
  source              = "../../modules/acr"
  acr_name            = var.acr_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.acr_sku
  tags                = var.tags
}

module "aks" {
  source              = "../../modules/aks"
  aks_cluster_name    = "${var.project_name}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  node_count          = var.aks_node_count
  vm_size             = var.aks_vm_size
  kubernetes_version  = var.kubernetes_version
  subnet_id           = module.network.subnet.id
  acr_id              = module.acr.acr_id
  tags                = var.tags
}

