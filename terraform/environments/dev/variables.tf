variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "healthcare-app-rg"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "healthcareappacr160689"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "healthcare-app"
}

variable "acr_sku" {
  description = "ACR SKU"
  type        = string
  default     = "Basic"
}

variable "aks_node_count" {
  description = "Number of AKS nodes"
  type        = number
  default     = 1
}

variable "aks_vm_size" {
  description = "AKS node VM size"
  type        = string
  default     = "Standard_B2s"
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
    Project     = "healthcare-app"
    Team        = "devops"
  }
}

variable "os_disk_size_gb" {
  description = "The size of the OS disk for each node in GB"
  type        = number
  default     = 30
}

variable "vm_size" {
  description = "The VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "node_count" {
  description = "The number of AKS nodes"
  type        = number
  default     = 1
}