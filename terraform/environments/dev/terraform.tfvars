# Azure Configuration
subscription_id      = "98712f56-5913-4408-99dc-21036074ccd7"
resource_group_name  = "rg-lbg-demo-dev"
location             = "centralus"

# Application Configuration
acr_name            = "acrlbgdemodev"
acr_login_server    = "acrlbgdemodev.azurecr.io"
environment         = "dev"
project_name        = "healthcare-app"

# AKS Configuration
aks_cluster_name    = "aks-lbg-demo-dev"
cluster_fqdn        = "lbg-demo-dev-a7awu88d.hcp.centralus.azmk8s.io"
kube_config         = "<sensitive>"
aks_node_count      = 1
aks_vm_size         = "Standard_B2s"
kubernetes_version  = "1.33.3"

# Tags
tags = {
  Environment = "dev"
  Project     = "healthcare-app"
  Team        = "devops"
}

