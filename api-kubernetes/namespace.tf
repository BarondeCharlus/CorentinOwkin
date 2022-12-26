resource "kubernetes_namespace" "api-dev" {
  metadata {
    name = "api-dev"
  }
}
