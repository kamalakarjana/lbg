variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "healthcare-app"
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