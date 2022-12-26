resource "kubernetes_service" "api-service" {
  metadata {
    name = "api-service"

    namespace = "api-dev"
    labels = {
      env = "dev"
    }
  }

  spec {
    selector = {
      env = kubernetes_deployment.api-deployment.metadata.0.labels.env
    }
    session_affinity = "ClientIP"
    port {
      port        = 5000
      target_port = 5005
    }

  }

  depends_on = [
    kubernetes_namespace.api-dev,
    kubernetes_deployment.api-deployment
  ]

}
