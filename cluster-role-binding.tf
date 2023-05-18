resource "kubernetes_cluster_role_binding_v1" "systemteam_admin" {
  metadata {
    name = "systemteam-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "Group"
    name      = "systemteam-admin"
    api_group = "rbac.authorization.k8s.io"
  }
}
resource "kubernetes_cluster_role_binding_v1" "keycloak_group" {
  metadata {
    name = "keycloak-${var.cluster_name}-admin-cluster-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "Group"
    name      = "${var.cluster_name}-admin"
    api_group = "rbac.authorization.k8s.io"
  }
}