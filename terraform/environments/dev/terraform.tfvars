subscription_id = "98712f56-5913-4408-99dc-21036074ccd7"

# Environment Configuration
location            = "westus2"
resource_group_name = "healthcare-app-rg-dev"
environment         = "dev"
project_name        = "healthcare"

# ACR Configuration  
acr_name = "kamalj2kkkk"
acr_sku  = "Basic"

# AKS Configuration
aks_cluster_name   = "healthcare-aks-cluster-dev"
node_count         = 1
vm_size            = "Standard_B2s"
kubernetes_version = "1.33.3"

# Network Configuration
vnet_address_space    = ["10.0.0.0/16"]
subnet_address_prefix = "10.0.1.0/24"

# Tags
tags = {
  Environment = "dev"
  Project     = "healthcare"
  Team        = "devops"
  CostCenter  = "IT"
}
