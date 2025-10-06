environment = "prod"
project_name = "healthcare"
acr_name = "healthcareappacr160689"
acr_sku = "Premium"
aks_node_count = 5
aks_vm_size = "Standard_D4s_v3"
kubernetes_version = "1.26.3"

tags = {
  Project     = "healthcare-app"
  Environment = "prod"
  ManagedBy   = "terraform"
  Critical    = "true"
}