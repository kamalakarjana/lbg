variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-lbg-demo-dev"  # Updated for demo
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-lbg-demo-dev"  # Updated for demo
}

variable "acr_name" {
  description = "Name of Azure Container Registry"
  type        = string
  default     = "acrlbgdemodev"  # Updated for demo
}

variable "use_existing_acr" {
  description = "Whether to use existing ACR or create new one"
  type        = bool
  default     = false  # Changed to false to create new ACR
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

variable "cluster_version" {
  description = "AKS cluster version"
  type        = string
  default     = "1.27"
}

variable "node_count" {
  description = "Number of AKS nodes"
  type        = number
  default     = 2
}

variable "node_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
}