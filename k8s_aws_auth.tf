resource "kubernetes_config_map" "aws_auth_configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<YAML
- rolearn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-${var.cluster_name}-worker-role
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
- rolearn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.Admin_username}
  username: ${var.Admin_username}
  groups:
    - system:masters
YAML
  }

  depends_on = [
    aws_eks_cluster.this,
  ]
}
