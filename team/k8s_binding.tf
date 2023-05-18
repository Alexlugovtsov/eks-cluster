resource "kubernetes_role_binding" "dev" {
  metadata {
    name      = "admin"
    namespace = kubernetes_namespace.dev.id
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = var.student_name
    namespace = kubernetes_namespace.dev.id
  }
}
resource "kubernetes_role_binding" "prod" {
  metadata {
    name      = "admin"
    namespace = kubernetes_namespace.prod.id
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = var.student_name
    namespace = kubernetes_namespace.prod.id
  }
}
