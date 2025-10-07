# Azure Configuration
variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westus2"
}

# Resource Naming
variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "healthcare-app-rg-dev"
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

# ACR Configuration
variable "acr_name" {
  description = "ACR name base (will have random suffix added)"
  type        = string
  default     = "kamalj2kkkk"
}

variable "acr_sku" {
  description = "ACR SKU"
  type        = string
  default     = "Basic"
}

# AKS Configuration
variable "aks_cluster_name" {
  description = "AKS cluster name"
  type        = string
  default     = "healthcare-aks-cluster-dev"
}

variable "node_count" {
  description = "Number of AKS nodes"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.33.3"
}

# Network Configuration
variable "vnet_address_space" {
  description = "Virtual network address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Subnet address prefix"
  type        = string
  default     = "10.0.1.0/24"
}

# Tags
variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "healthcare"
    Team        = "devops"
  }
}