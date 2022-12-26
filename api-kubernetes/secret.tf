resource "kubernetes_secret" "api-secret" {
  metadata {
    name = "api-secret"

    namespace = "api-dev"
    labels = {
      env = "dev"
    }
  }

  type = "Opaque"

  data = {
    "SECRET_KEY" = base64encode("${var.SECRET_KEY}")
  }

  depends_on = [
    kubernetes_namespace.api-dev
  ]

}
