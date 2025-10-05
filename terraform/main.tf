# New Resource Group for LBG demo cluster
resource "azurerm_resource_group" "lbg_demo" {
  name     = "rg-lbg-demo-${var.environment}"
  location = var.location
  tags = {
    environment = var.environment
    project     = "healthcare-lbg-demo"
    branch      = "dev"
    version     = "3.0.0-demo"
  }
}

# Create new ACR for demo
resource "azurerm_container_registry" "lbg_demo_acr" {
  name                = "acrlbgdemo${var.environment}"
  resource_group_name = azurerm_resource_group.lbg_demo.name
  location            = azurerm_resource_group.lbg_demo.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    environment = var.environment
    purpose     = "lbg-demo"
  }
}

# Create new AKS Cluster for demo
resource "azurerm_kubernetes_cluster" "lbg_demo_aks" {
  name                = "aks-lbg-demo-${var.environment}"
  location            = azurerm_resource_group.lbg_demo.location
  resource_group_name = azurerm_resource_group.lbg_demo.name
  dns_prefix          = "lbg-demo-${var.environment}"
  kubernetes_version  = var.cluster_version

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_vm_size
    enable_auto_scaling = true
    min_count  = 1
    max_count  = 3
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

# Attach ACR to AKS
resource "azurerm_role_assignment" "acr_attach" {
  principal_id                     = azurerm_kubernetes_cluster.lbg_demo_aks.kubelet_identity[0].object_id
  role_definition_name            = "AcrPull"
  scope                           = azurerm_container_registry.lbg_demo_acr.id
  skip_service_principal_auth_check = true
}