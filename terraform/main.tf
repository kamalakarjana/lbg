resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    environment = var.environment
    project     = "healthcare-app"
  }
}

# Use existing Azure Container Registry (data source)
data "azurerm_container_registry" "acr" {
  count               = var.use_existing_acr ? 1 : 0
  name                = var.acr_name
  resource_group_name = var.acr_resource_group_name
}

# Create new ACR only if use_existing_acr is false
resource "azurerm_container_registry" "acr" {
  count               = var.use_existing_acr ? 0 : 1
  name                = "${var.acr_name}${random_id.acr_suffix[0].hex}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Random ID for ACR name suffix (only used when creating new ACR)
resource "random_id" "acr_suffix" {
  count       = var.use_existing_acr ? 0 : 1
  byte_length = 4
}

# Create AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "healthcare-aks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.environment
  }
}

# ACR role assignment removed - manually configured via: az aks update --attach-acr