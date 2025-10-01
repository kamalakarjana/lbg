environment          = "prod"
app_service_plan_sku = "S2"
acr_sku              = "Standard"

tags = {
  Project     = "healthcare-app"
  Environment = "prod"
  ManagedBy   = "terraform"
}