variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "healthcare"
}

variable "acr_name" {
  description = "ACR name"
  type        = string
  default     = "healthcareappacr160689"
}

variable "acr_sku" {
  description = "ACR SKU"
  type        = string
  default     = "Premium"
}

variable "aks_node_count" {
  description = "AKS node count"
  type        = number
  default     = 5
}

variable "aks_vm_size" {
  description = "AKS VM size"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.33.3"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}