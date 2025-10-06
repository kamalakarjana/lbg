# New Resource Group for LBG demo cluster
resource "azurerm_resource_group" "main" {
  name     = "rg-lbg-demo-${var.environment}"
  location = var.location
  tags = {
    environment = var.environment
    project     = "healthcare-lbg-demo"
    branch      = "dev"
    version     = "3.0.0-demo"
  }
}

# Create new ACR for demo - Basic SKU (cheapest)
resource "azurerm_container_registry" "acr" {
  name                = "acrlbgdemo${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    environment = var.environment
    purpose     = "lbg-demo"
  }
}

# Create new AKS Cluster for demo - Minimum AKS requirements
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-lbg-demo-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "lbg-demo-${var.environment}"
  kubernetes_version  = var.cluster_version

  # Minimum node pool configuration that meets AKS requirements
  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_B2s"
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
  }

  tags = {
    environment = var.environment
    project     = "healthcare-lbg-demo"
    branch      = "dev"
    demo        = "true"
  }
}

# COMMENT OUT OR REMOVE THIS BLOCK - It's causing permission issues
# resource "azurerm_role_assignment" "acr_attach" {
#   principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
#   role_definition_name            = "AcrPull"
#   scope                           = azurerm_container_registry.acr.id
# }