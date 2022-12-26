resource "kubernetes_config_map" "api-config-map" {
  metadata {
    name = "api-config-map"

    namespace = "api-dev"
    labels = {
      env = "dev"
    }
  }

  data = {
    CLUSTER_INFO = "DEV"
  }

  depends_on = [
    kubernetes_namespace.api-dev
  ]

}
