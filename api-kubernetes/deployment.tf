resource "kubernetes_deployment" "api-deployment" {
  metadata {
    name      = "api-deployment"
    namespace = "api-dev"
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
          image             = "api-owkin:latest"
          name              = "api"
          image_pull_policy = "Never"

          working_dir = "/srv/core"
          command     = ["/bin/sh", "-c"]
          args        = ["python manage.py makemigrations && python manage.py migrate && gunicorn --config gunicorn-cfg.py core.wsgi"]

          security_context {
            run_as_user                = "1000"
            allow_privilege_escalation = "false"
          }

          port {
            container_port = "5005"
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

          env {
            name = "CLUSTER_INFO"
            value_from {
              config_map_key_ref {
                name     = "api-config-map"
                key      = "CLUSTER_INFO"
                optional = "false"
              }
            }
          }

          env {
            name = "SECRET_KEY"
            value_from {
              secret_key_ref {
                name     = "api-secret"
                key      = "SECRET_KEY"
                optional = "false"
              }
            }
          }

        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.api-dev,
    kubernetes_config_map.api-config-map,
    kubernetes_secret.api-secret
  ]

  timeouts {
    create = "20s"
    update = "20s"
    delete = "20s"
  }

}
