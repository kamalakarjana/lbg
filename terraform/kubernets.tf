# Kubernetes provider configuration
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

# Namespace for our application
resource "kubernetes_namespace" "healthcare" {
  metadata {
    name = "healthcare-${var.environment}"
    labels = {
      environment = var.environment
      project     = var.project_name
    }
  }
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
        container {
          image = "${azurerm_container_registry.acr.login_server}/patient-service:${var.docker_image_tags.patient_service}"
          name  = "patient-service"

          port {
            container_port = 3000
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "200m"
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

# Patient Service Service
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
        container {
          image = "${azurerm_container_registry.acr.login_server}/appointment-service:${var.docker_image_tags.appointment_service}"
          name  = "appointment-service"

          port {
            container_port = 3001
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "200m"
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

# Appointment Service Service
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

# Ingress Controller with NGINX
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.13"
  namespace  = "ingress-nginx"

  create_namespace = true

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe"
    value = "true"
  }
}

# Ingress Resource
resource "kubernetes_ingress_v1" "healthcare" {
  depends_on = [helm_release.nginx_ingress]

  metadata {
    name      = "healthcare-ingress"
    namespace = kubernetes_namespace.healthcare.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/patients"
          backend {
            service {
              name = "patient-service"
              port {
                number = 80
              }
            }
          }
        }

        path {
          path = "/appointments"
          backend {
            service {
              name = "appointment-service"
              port {
                number = 80
              }
            }
          }
        }

        path {
          path = "/"
          backend {
            service {
              name = "patient-service"
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
