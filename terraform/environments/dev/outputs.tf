# Resource Group Outputs
output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Resource group location"
  value       = azurerm_resource_group.main.location
}

# ACR Outputs
output "acr_name" {
  description = "ACR name"
  value       = module.acr.acr_name
}

output "acr_login_server" {
  description = "ACR login server URL"
  value       = module.acr.acr_login_server
}

# AKS Outputs
output "aks_cluster_name" {
  description = "AKS cluster name"
  value       = module.aks.aks_name
}

output "aks_id" {
  description = "AKS cluster ID"
  value       = module.aks.aks_id
}

output "cluster_fqdn" {
  description = "AKS cluster FQDN"
  value       = module.aks.host
  sensitive   = true
}

# Network Outputs
output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = module.network.aks_subnet_id
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.network.vnet_id
}

output "subnet_name" {
  description = "Name of the AKS subnet"
  value       = module.network.subnet_name
}

# Kubernetes Access
output "kube_config" {
  description = "Kubernetes configuration"
  value       = module.aks.kube_config
  sensitive   = true
}

# Utility Outputs
output "unique_suffix" {
  description = "Random suffix used for unique naming"
  value       = random_id.suffix.hex
}