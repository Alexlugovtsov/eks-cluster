resource "kubernetes_namespace" "dev" {
  metadata {
    name = "${var.student_name}-dev"
  }
}
resource "kubernetes_namespace" "prod" {
  metadata {
    name = "${var.student_name}-prod"
  }
}
