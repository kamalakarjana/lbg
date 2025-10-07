output "aks_subnet_id" {
  description = "AKS subnet ID"
  value       = azurerm_subnet.aks.id
}

output "vnet_id" {
  description = "Virtual network ID"
  value       = azurerm_virtual_network.main.id
}

output "subnet_name" {
  description = "Subnet name"
  value       = azurerm_subnet.aks.name
}

output "vnet_name" {
  description = "Virtual network name"
  value       = azurerm_virtual_network.main.name
}

output "network_security_group_id" {
  description = "Network security group ID"
  value       = azurerm_network_security_group.aks.id
}