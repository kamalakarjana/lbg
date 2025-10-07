resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.environment}-${var.project_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.vnet_address_space
  tags                = var.tags

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_subnet" "aks" {
  name                 = "snet-aks-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_address_prefix]

  service_endpoints = ["Microsoft.ContainerRegistry"]

  depends_on = [azurerm_virtual_network.main]
}

resource "azurerm_network_security_group" "aks" {
  name                = "nsg-aks-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id

  depends_on = [
    azurerm_subnet.aks,
    azurerm_network_security_group.aks
  ]
}