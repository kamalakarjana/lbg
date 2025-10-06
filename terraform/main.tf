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
  sku                 = "Basic"  # Cheapest option
  admin_enabled       = true

  tags = {
    environment = var.environment
    purpose     = "lbg-demo"
  }
}

# Create new AKS Cluster for demo - Minimal configuration
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-lbg-demo-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "lbg-demo-${var.environment}"
  kubernetes_version  = var.cluster_version

  # Minimal node pool configuration
  default_node_pool {
    name                = "default"
    node_count          = 1  # Single node only
    vm_size             = "Standard_B1s"  # Smallest burstable instance
    enable_auto_scaling = false  # Disable auto-scaling to save costs
  }

  # Use system-assigned identity (free)
  identity {
    type = "SystemAssigned"
  }

  # Basic network profile
  network_profile {
    network_plugin = "kubenet"  # Simpler and cheaper than Azure CNI
    network_policy = "calico"
  }

  tags = {
    environment = var.environment
    project     = "healthcare-lbg-demo"
    branch      = "dev"
    demo        = "true"
  }
}

# Attach ACR to AKS
resource "azurerm_role_assignment" "acr_attach" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name            = "AcrPull"
  scope                           = azurerm_container_registry.acr.id
}