terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23.0"
    }
  }
}

provider "kubernetes" {}

resource "kubernetes_deployment" "todo_app" {
  metadata {
    name = "todo-flask-deployment"
    labels = { app = "todo-flask" }
  }

  spec {
    replicas = 2
    selector {
      match_labels = { app = "todo-flask" }
    }

    template {
      metadata {
        labels = { app = "todo-flask" }
      }

      spec {
        container {
          name  = "todo-flask"
          image = var.docker_image_name
          port { container_port = 5000 }
          
          resources {
            limits = { cpu = "500m", memory = "512Mi" }
            requests = { cpu = "250m", memory = "256Mi" }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "todo_service" {
  metadata { name = "todo-flask-service" }
  spec {
    selector = { app = "todo-flask" }
    type     = "NodePort"
    port {
      port        = 80
      target_port = 5000
    }
  }
}

variable "docker_image_name" {
  type        = string
  description = "Target GAR immutable image reference tag passed directly from GitHub workflow context"
}
