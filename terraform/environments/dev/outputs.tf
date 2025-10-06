output "acr_name" {
  description = "ACR login server name"
  value       = module.acr.acr_login_server
}

output "aks_cluster_name" {
  description = "healthcare-aks-cluster"
  value       = module.aks.aks_name
}

output "resource_group_name" {
  description = "Resource group name"
  value       = var.resource_group_name
}

output "loadbalancer_public_ip" {
  description = "Load balancer public IP"
  value       = module.network.loadbalancer_public_ip
}

output "acr_login_server" {
  description = "ACR login server URL"
  value       = module.acr.acr_login_server
}

output "kube_config" {
  description = "Kubernetes configuration"
  value       = module.aks.kube_config
  sensitive   = true
}