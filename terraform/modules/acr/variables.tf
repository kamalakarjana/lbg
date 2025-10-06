variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}

variable "sku" {
  description = "ACR SKU"
  type        = string
  default     = "Basic"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "healthcare-app"
    Team        = "devops"
  }
}