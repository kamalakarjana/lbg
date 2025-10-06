environment = "staging"
project_name = "healthcare"
acr_name = "healthcareappacr160689"
acr_sku = "Standard"
aks_node_count = 3
aks_vm_size = "Standard_D2s_v3"

tags = {
  Project     = "healthcare-app"
  Environment = "staging"
  ManagedBy   = "terraform"
}