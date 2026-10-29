terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

variable "image" {
  type    = string
  default = "ghcr.io/taniyeah/l00205444-mini-pipeline:main"
}

resource "kubernetes_deployment_v1" "app" {
  metadata {
    name   = "mini-pipeline"
    labels = { app = "mini-pipeline" }
  }

  spec {
    replicas = 2

    selector {
      match_labels = { app = "mini-pipeline" }
    }

    template {
      metadata {
        labels = { app = "mini-pipeline" }
      }

      spec {
        container {
          name              = "app"
          image             = var.image
          image_pull_policy = "IfNotPresent"

          port {
            container_port = 3000
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 3000
            }
            initial_delay_seconds = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "app" {
  metadata {
    name = "mini-pipeline"
  }

  spec {
    selector = { app = "mini-pipeline" }

    port {
      port        = 80
      target_port = 3000
    }

    type = "NodePort"
  }
}
