output "aks_subnet_id" {
  description = "AKS subnet ID"
  value       = azurerm_subnet.aks.id
}

# Comment out public IP output since we're not creating it
/*
output "loadbalancer_public_ip" {
  description = "Load balancer public IP address"
  value       = azurerm_public_ip.loadbalancer.ip_address
}
*/

output "virtual_network_name" {
  description = "Virtual network name"
  value       = azurerm_virtual_network.main.name
}

output "subnet_name" {
  description = "Subnet name"
  value       = azurerm_subnet.aks.name
}


output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}
