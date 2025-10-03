environment   = "staging"
location      = "East US"
node_count    = 3
aks_sku_tier  = "Free"
vm_size       = "Standard_B2s"

tags = {
  Project     = "HealthcareApp-LBG"
  Environment = "staging"
  Team        = "LBG-QA"
}
