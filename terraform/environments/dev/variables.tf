variable "location" {
  description = "Azure region"
  type        = string
  default     = "westus2"  # Make sure this is NOT eastus
}

variable "node_count" {
  description = "Number of AKS nodes"
  type        = number
  default     = 1  # Reduced to avoid quota issues
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"  # Smaller VM size
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "healthcare-app-rg-dev"
}

variable "aks_cluster_name" {
  description = "AKS cluster name"
  type        = string
  default     = "healthcare-aks-cluster-dev"
}

variable "acr_name" {
  description = "ACR name"
  type        = string
  default     = "kamalj2kkkk"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "healthcare"
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "acr_sku" {
  description = "ACR SKU"
  type        = string
  default     = "Basic"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.33.3"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "healthcare"
  }
}

variable "vnet_address_space" {
  description = "Virtual network address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}
