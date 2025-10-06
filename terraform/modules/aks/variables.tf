variable "resource_group_name" {
  description = "healthcare-app-rg"
  type        = string
}

variable "location" {
  description = "eastus"
  type        = string
}

variable "environment" {
  description = "dev"
  type        = string
}

variable "project_name" {
  description = "Healthcare-app"
  type        = string
  default     = "healthcare"
}

variable "node_count" {
  description = "Number of AKS nodes"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.26.3"
}

variable "subnet_id" {
  description = "Subnet ID for AKS"
  type        = string
}

variable "acr_id" {
  description = "ACR resource ID"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}