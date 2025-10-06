variable "environment" {
  description = "The environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "UK South"
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Azure service principal client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Azure service principal client secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
  sensitive   = true
}

variable "use_existing_acr" {
  description = "Whether to use an existing ACR or create a new one"
  type        = bool
  default     = false
}

variable "cluster_version" {
  description = "Kubernetes version for AKS cluster"
  type        = string
  default     = "1.33.3"
}

variable "node_count" {
  description = "Default number of nodes in AKS cluster"
  type        = number
  default     = 2
}

variable "node_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
}