environment          = "dev"
app_service_plan_sku = "B1"
acr_sku              = "Basic"

tags = {
  Project     = "healthcare-app"
  Environment = "dev"
  ManagedBy   = "terraform"
}