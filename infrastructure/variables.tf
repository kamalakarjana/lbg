variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-lbg-demo-dev"
}

variable "azurerm_kubernetes_cluster" {
  description = "The name of the resource group"
  type        = string
  default     = "lgb-aks-cluster"
}

variable "location" {
  description = "The Azure region to deploy to"
  type        = string
  default     = "Central US"
}

variable "environment" {
  description = "The environment (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
  default     = "acrlbgdemodev"
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
  default     = "lgb-aks-cluster"
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "vnet-dev-lbg-app"
}

variable "public_ip_name" {
  description = "The name of the public IP address for the load balancer"
  type        = string
  default     = "lbg-dev-lbg-app"
}

variable "node_count" {
  description = "The number of nodes in the AKS cluster"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "The size of the VMs in the AKS cluster"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "kubernetes_version" {
  description = "The Kubernetes version"
  type        = string
  default     = "1.33.3"
}