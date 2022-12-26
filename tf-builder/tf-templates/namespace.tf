resource "kubernetes_namespace" "namespace-{{ID}}-owkin" {
  metadata {
    name = "namespace-{{ID}}-owkin"
  }
}
