# Azure Configuration
subscription_id      = "8b617ec6-11a6-4c2b-aa4a-150a2a8e14fc"
resource_group_name  = "healthcare-app-rg"
location            = "East US"

# Application Configuration
acr_name            = "healthcareappacr160689"
environment         = "dev"
project_name        = "healthcare-app"

# ACR Configuration
acr_sku            = "Basic"

# AKS Configuration
aks_node_count     = 1
aks_vm_size        = "Standard_B2s"
kubernetes_version = "1.27.3"

# Tags
tags = {
  Environment = "dev"
  Project     = "healthcare-app"
  Team        = "devops"
}