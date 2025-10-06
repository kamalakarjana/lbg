variable "resource_group_name" {
  description = "Resource group name for the dev environment"
  type        = string
  default     = "healthcare-app-rg-dev"
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "Central US"
}

variable "acr_name" {
  description = "Azure Container Registry name for dev environment"
  type        = string
  default     = "healthcareappacr9000dev"
}

variable "sku" {
  description = "ACR SKU"
  type        = string
  default     = "Basic"  # Change to "Standard" or "Premium" if needed
}

variable "tags" {
  description = "Resource tags for tracking environment and ownership"
  type        = map(string)
  default = {
    environment = "dev"
    owner       = "kamalakar"
    project     = "healthcare-app"
  }
}
