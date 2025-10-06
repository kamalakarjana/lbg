# terraform/modules/network/outputs.tf
output "aks_subnet_id" {
  description = "AKS subnet ID"
  value       = azurerm_subnet.aks.id
}

output "loadbalancer_public_ip" {
  description = "Load balancer public IP address"
  value       = azurerm_public_ip.loadbalancer.ip_address
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  description = "Virtual network name"
  value       = azurerm_virtual_network.main.name
}