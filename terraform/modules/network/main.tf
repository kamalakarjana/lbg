resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.environment}-${var.project_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "aks" {
  name                 = "snet-aks-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_address_prefix]

  # Explicit dependency to avoid timing issues
  depends_on = [
    azurerm_virtual_network.main
  ]
}

# We'll comment out public IP creation for now to avoid quota issues
# AKS will create its own load balancer automatically
/*
resource "azurerm_public_ip" "loadbalancer" {
  name                = "pip-lb-${var.environment}-${var.project_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}
*/

resource "azurerm_network_security_group" "aks" {
  name                = "nsg-aks-dev"
  location            = var.location
  resource_group_name = var.resource_group_name
}
