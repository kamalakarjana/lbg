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

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}