output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "patient_service_url" {
  description = "URL of the Patient Service"
  value       = "https://${azurerm_linux_web_app.patient_service.default_hostname}"
}

output "appointment_service_url" {
  description = "URL of the Appointment Service"
  value       = "https://${azurerm_linux_web_app.appointment_service.default_hostname}"
}

output "container_registry_url" {
  description = "URL of the Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "application_insights_id" {
  description = "ID of Application Insights"
  value       = azurerm_application_insights.main.id
}