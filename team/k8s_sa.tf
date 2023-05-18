resource "kubernetes_service_account" "dev" {
  metadata {
    name      = var.student_name
    namespace = kubernetes_namespace.dev.id
  }
}
resource "kubernetes_service_account" "prod" {
  metadata {
    name      = var.student_name
    namespace = kubernetes_namespace.prod.id
  }
}
resource "kubernetes_secret_v1" "dev" {
  metadata {
    name        = "admin"
    namespace   = kubernetes_namespace.dev.id
    annotations = {
      "kubernetes.io/service-account.name" = var.student_name
    }
  }

  type = "kubernetes.io/service-account-token"
}
resource "kubernetes_secret_v1" "prod" {
  metadata {
    name        = "admin"
    namespace   = kubernetes_namespace.prod.id
    annotations = {
      "kubernetes.io/service-account.name" = var.student_name
    }
  }

  type = "kubernetes.io/service-account-token"
}
