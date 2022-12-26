resource "kubernetes_ingress_v1" "api-ingress" {
  metadata {
    name = "api-ingress"

    namespace = "api-dev"
    labels = {
      env = "dev"
    }
  }
  spec {
    default_backend {
      service {
        name = "api-service"
        port {
          number = 5000
        }
      }
    }

    rule {
      http {
        path {
          backend {
            service {
              name = "api-service"
              port {
                number = 5000
              }
            }
          }

          path = "/"
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.api-dev,
    kubernetes_deployment.api-deployment,
    kubernetes_service.api-service,
  ]

}
