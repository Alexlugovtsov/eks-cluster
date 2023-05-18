module "lb_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.cluster_name}-lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = aws_iam_openid_connect_provider.this.arn
      namespace_service_accounts = ["aws-alb:aws-load-balancer-controller"]
    }
  }
  tags = {
    Environment = var.environment_name
    Terraform   = "true"
  }
}
# https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller
resource "helm_release" "lb" {
  name       = "aws-load-balancer-controller"
  version    = "1.4.8"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  create_namespace = true
  namespace  = "aws-alb"
  depends_on  = [module.lb_role,aws_eks_node_group.managed_group]

values = [
  <<-EOF
  clusterName: ${var.cluster_name}
  vpcId: ${var.vpc_id}
  region: ${var.region}
  replicaCount: 1
  hostNetwork: true
  enableShield: false
  image:
    repository: 602401143452.dkr.ecr.eu-central-1.amazonaws.com/amazon/aws-load-balancer-controller
  serviceAccount:
    create: true
    annotations:
      eks.amazonaws.com/role-arn: ${module.lb_role.iam_role_arn}
  EOF
]
}
