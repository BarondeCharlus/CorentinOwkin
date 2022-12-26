resource "kubernetes_network_policy" "networkpolicy-{{ID}}-owkin" {
  metadata {
    name      = "networkpolicy-{{ID}}-owkin"
    namespace = "namespace-{{ID}}-owkin"
  }

  spec {
    pod_selector {
      match_expressions {
        key      = "name"
        operator = "In"
        values   = ["deployment-{{ID}}-owkin"]
      }
    }
    ingress {
      ports {
        port     = "http"
        protocol = "TCP"
      }
      from {
        namespace_selector {
          match_labels = {
            name = "namespace-{{ID}}-owkin"
          }
        }
      }
    }

    egress {
    to {
        ip_block {
          cidr = "0.0.0.0/0"
          except = [
            "192.168.49.2/32",
            ]
        }
      }
    }

    policy_types = ["Ingress", "Egress"]
  }
}
