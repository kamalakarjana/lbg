# Patient Service Deployment
resource "kubernetes_deployment" "patient_service" {
  metadata {
    name      = "patient-service"
    namespace = kubernetes_namespace.healthcare.metadata[0].name
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
          name  = "patient-service"
          image = "${var.acr_name}.azurecr.io/patient-service:latest"

          port {
            container_port = 3000
          }

          env {
            name  = "PORT"
            value = "3000"
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
            period_seconds        = 10
          }
        }
      }
    }
  }

  # Don't wait for rollout during Terraform apply
  wait_for_rollout = false
}

# Appointment Service Deployment  
resource "kubernetes_deployment" "appointment_service" {
  metadata {
    name      = "appointment-service"
    namespace = kubernetes_namespace.healthcare.metadata[0].name
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
          name  = "appointment-service"
          image = "${var.acr_name}.azurecr.io/appointment-service:latest"

          port {
            container_port = 3001
          }

          env {
            name  = "PORT"
            value = "3001"
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
            period_seconds        = 10
          }
        }
      }
    }
  }

  # Don't wait for rollout during Terraform apply
  wait_for_rollout = false
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

    type = "LoadBalancer"
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

    type = "LoadBalancer"
  }
}