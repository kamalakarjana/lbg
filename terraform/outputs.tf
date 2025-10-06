output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "acr_login_server" {
  description = "The login server of the ACR"
  value       = azurerm_container_registry.acr.login_server
}

output "kube_config" {
  description = "Kubernetes configuration"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "acr_name" {
  description = "The name of the ACR"
  value       = azurerm_container_registry.acr.name
}

output "cluster_fqdn" {
  description = "The FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}