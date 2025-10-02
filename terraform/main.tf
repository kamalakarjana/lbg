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
  resource_group_name = var.resource_group_name
}

# Create new ACR only if use_existing_acr is false
resource "azurerm_container_registry" "acr" {
  count               = var.use_existing_acr ? 0 : 1
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
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

# Grant AKS access to ACR
resource "azurerm_role_assignment" "aks_acr" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.use_existing_acr ? data.azurerm_container_registry.acr[0].id : azurerm_container_registry.acr[0].id
  skip_service_principal_aad_check = true
}