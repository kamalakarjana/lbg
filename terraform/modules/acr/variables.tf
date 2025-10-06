variable "resource_group_name" {
  description = "healthcare-app-rg"
  type        = string
}

variable "location" {
  description = "eastus"
  type        = string
}

variable "acr_name" {
  description = "healthcareappacr160689"
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
  default     = {}
}