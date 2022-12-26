resource "kubernetes_deployment" "deployment-{{ID}}-owkin" {
  metadata {
    name      = "deployment-{{ID}}-owkin"
    namespace = "namespace-{{ID}}-owkin"
    labels = {
      env = "dev"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        env = "dev"
      }
    }

    template {
      metadata {
        labels = {
          env = "dev"
        }
      }

      spec {
        security_context {
          run_as_user  = "1000"
          run_as_group = "3000"
          fs_group     = "2000"
        }

        container {
          image             = "{{ID}}:latest"
          name              = "{{ID}}"
          image_pull_policy = "Never"

          volume_mounts {
            name = "data"
            mountPath = "/data/"
          }

          security_context {
            run_as_user                = "1000"
            allow_privilege_escalation = "false"
          }

          port {
            container_port = "9876"
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.namespace-{{ID}}-owkin,
  ]

  timeouts {
    create = "20s"
    update = "20s"
    delete = "20s"
  }

}
