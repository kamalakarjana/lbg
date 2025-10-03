terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "hackton-lbg-test"
    storage_account_name = "kamalj2kar"
    container_name       = "kamalj2kcontainer"
    key                  = "healthcare-${var.environment}.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Variables
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "node_count" {
  description = "Number of AKS nodes"
  type        = number
  default     = 2
}

variable "aks_sku_tier" {
  description = "AKS SKU tier"
  type        = string
  default     = "Free"
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default = {
    Project = "HealthcareApp-LBG"
  }
}

# Local values
locals {
  environment_map = {
    dev = {
      node_count = 2
      vm_size    = "Standard_B2s"
      sku_tier   = "Free"
    }
    staging = {
      node_count = 3
      vm_size    = "Standard_B2s"
      sku_tier   = "Free"
    }
    prod = {
      node_count = 4
      vm_size    = "Standard_D2s_v3"
      sku_tier   = "Paid"
    }
  }
  
  config = local.environment_map[var.environment]
  final_tags = merge(var.tags, { 
    Environment = var.environment
    Team        = "LBG"
    CostCenter  = var.environment == "prod" ? "Production" : var.environment == "staging" ? "Testing" : "R&D"
  })
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.environment}-healthcare-lbg"
  location = var.location
  tags     = local.final_tags
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.environment}-healthcare-lbg"
  address_space       = ["10.${index(["dev", "staging", "prod"], var.environment)}.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = azurerm_resource_group.main.tags
}

# AKS Subnet
resource "azurerm_subnet" "aks" {
  name                 = "snet-aks-${var.environment}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.${index(["dev", "staging", "prod"], var.environment)}.1.0/24"]
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-${var.environment}-healthcare-lbg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aks-${var.environment}-lbg"
  kubernetes_version  = "1.27.7"
  sku_tier            = local.config.sku_tier

  default_node_pool {
    name           = "default"
    node_count     = local.config.node_count
    vm_size        = local.config.vm_size
    vnet_subnet_id = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr   = "10.${index(["dev", "staging", "prod"], var.environment)}.2.0/24"
    dns_service_ip = "10.${index(["dev", "staging", "prod"], var.environment)}.2.10"
  }

  tags = azurerm_resource_group.main.tags
}

# Public IP for Ingress
resource "azurerm_public_ip" "ingress" {
  name                = "pip-${var.environment}-ingress-lbg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_kubernetes_cluster.main.node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = azurerm_resource_group.main.tags
}

# Outputs
output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "ingress_ip" {
  value = azurerm_public_ip.ingress.ip_address
}

output "cluster_details" {
  value = {
    name          = azurerm_kubernetes_cluster.main.name
    resource_group = azurerm_resource_group.main.name
    location      = azurerm_resource_group.main.location
    node_count    = local.config.node_count
    environment   = var.environment
    vm_size       = local.config.vm_size
  }
}
