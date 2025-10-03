environment   = "prod"
location      = "East US 2"
node_count    = 4
aks_sku_tier  = "Paid"
vm_size       = "Standard_D2s_v3"

tags = {
  Project     = "HealthcareApp-LBG"
  Environment = "prod"
  Team        = "LBG-Operations"
}
