variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "healthcare-app-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "healthcare-aks-cluster"
}

variable "acr_name" {
  description = "Name of Azure Container Registry"
  type        = string
  default     = "kamalj2kkkk"
}

variable "use_existing_acr" {
  description = "Whether to use existing ACR or create new one"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Azure Client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Azure Client Secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  sensitive   = true
}