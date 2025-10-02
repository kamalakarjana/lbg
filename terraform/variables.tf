variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "healthcareapp"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "healthcare-app"
    ManagedBy = "terraform"
  }
}

variable "aks_node_count" {
  description = "Number of AKS worker nodes"
  type        = number
  default     = 2
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "acr_sku" {
  description = "SKU for Azure Container Registry"
  type        = string
  default     = "Basic"
}

variable "docker_image_tags" {
  description = "Docker image tags for services"
  type        = map(string)
  default = {
    patient_service     = "latest"
    appointment_service = "latest"
  }
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



