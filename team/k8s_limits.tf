resource "kubernetes_limit_range" "dev" {
  metadata {
    name = "${var.student_name}-limit"
    namespace = kubernetes_namespace.dev.id
  }
  spec {
    limit {
      type = "Container"
      default = {
        cpu    = "20m"
        memory = "100Mi"
      }
      max = {
        cpu    = "500m"
        memory = "1Gi"
      }
    }
    limit {
      type = "PersistentVolumeClaim"
      max = {
        storage = "1G"
      }
    }
  }
}
resource "kubernetes_limit_range" "prod" {
  metadata {
    name = "${var.student_name}-limit"
    namespace = kubernetes_namespace.prod.id
  }
  spec {
    limit {
      type = "Container"
      default = {
        cpu    = "20m"
        memory = "100Mi"
      }
      max = {
        cpu    = "500m"
        memory = "1Gi"
      }
    }
    limit {
      type = "PersistentVolumeClaim"
      max = {
        storage = "1G"
      }
    }
  }
}
