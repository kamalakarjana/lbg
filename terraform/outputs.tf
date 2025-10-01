output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "acr_login_server" {
  description = "Login server of the Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "kube_config" {
  description = "Kubernetes config file"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "ingress_ip" {
  description = "IP address of the ingress controller"
  value       = helm_release.nginx_ingress.status != "deployed" ? "Pending" : data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.ip
}


data "kubernetes_service" "ingress_nginx" {
  depends_on = [helm_release.nginx_ingress]

  metadata {
    name      = "nginx-ingress-ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}
