terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
  
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.environment}-healthcare-app"
  location = var.location
  
  tags = {
    environment = var.environment
    project     = "healthcare-app"
  }
}

# Container Registry (using existing)
data "azurerm_container_registry" "existing" {
  name                = var.acr_name
  resource_group_name = var.acr_resource_group
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-${var.environment}-healthcare"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aks-${var.environment}"
  kubernetes_version  = "1.27.3"

  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = "Standard_B2s"
    enable_auto_scaling = false
    os_disk_size_gb     = 30
    type                = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
    service_cidr   = "10.0.0.0/16"
    dns_service_ip = "10.0.0.10"
  }

  tags = {
    environment = var.environment
    project     = "healthcare-app"
  }
}

# Attach ACR to AKS
resource "azurerm_role_assignment" "aks_acr" {
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.existing.id
  skip_service_principal_aad_check = true
}

# Kubernetes Provider
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
  }
}

# Kubernetes Namespace
resource "kubernetes_namespace" "healthcare" {
  metadata {
    name = "healthcare-${var.environment}"
  }
}

# ACR Pull Secret
resource "kubernetes_secret" "acr_secret" {
  metadata {
    name      = "acr-secret"
    namespace = kubernetes_namespace.healthcare.metadata[0].name
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${data.azurerm_container_registry.existing.login_server}" = {
          username = data.azurerm_container_registry.existing.admin_username
          password = data.azurerm_container_registry.existing.admin_password
          auth     = base64encode("${data.azurerm_container_registry.existing.admin_username}:${data.azurerm_container_registry.existing.admin_password}")
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

# Patient Service Deployment
resource "kubernetes_deployment" "patient_service" {
  metadata {
    name      = "patient-service"
    namespace = kubernetes_namespace.healthcare.metadata[0].name
    labels = {
      app = "patient-service"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "patient-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "patient-service"
        }
      }

      spec {
        image_pull_secrets {
          name = kubernetes_secret.acr_secret.metadata[0].name
        }

        container {
          image = "${data.azurerm_container_registry.existing.login_server}/patient-service:${var.image_tag}"
          name  = "patient-service"

          port {
            container_port = 3000
          }

          env {
            name  = "PORT"
            value = "3000"
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 3000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "patient_service" {
  metadata {
    name      = "patient-service"
    namespace = kubernetes_namespace.healthcare.metadata[0].name
  }

  spec {
    selector = {
      app = "patient-service"
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "ClusterIP"
  }
}

# Appointment Service Deployment
resource "kubernetes_deployment" "appointment_service" {
  metadata {
    name      = "appointment-service"
    namespace = kubernetes_namespace.healthcare.metadata[0].name
    labels = {
      app = "appointment-service"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "appointment-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "appointment-service"
        }
      }

      spec {
        image_pull_secrets {
          name = kubernetes_secret.acr_secret.metadata[0].name
        }

        container {
          image = "${data.azurerm_container_registry.existing.login_server}/appointment-service:${var.image_tag}"
          name  = "appointment-service"

          port {
            container_port = 3001
          }

          env {
            name  = "PORT"
            value = "3001"
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 3001
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 3001
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "appointment_service" {
  metadata {
    name      = "appointment-service"
    namespace = kubernetes_namespace.healthcare.metadata[0].name
  }

  spec {
    selector = {
      app = "appointment-service"
    }

    port {
      port        = 80
      target_port = 3001
    }

    type = "ClusterIP"
  }
}

# Ingress Controller
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  namespace  = "ingress"
  create_namespace = true

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }
}

# Application Ingress
resource "kubernetes_ingress_v1" "healthcare_app" {
  metadata {
    name      = "healthcare-app-ingress"
    namespace = kubernetes_namespace.healthcare.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/patients(/|$)(.*)"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.patient_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }

        path {
          path = "/appointments(/|$)(.*)"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.appointment_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}