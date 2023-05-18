# Create EKS role with AmazonEKSClusterPolicy attached
resource "aws_iam_role" "eks_role" {
  name = "eks-${var.cluster_name}-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids              = var.public_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
    #public_access_cidrs     = var.admin_ips
    security_group_ids      = [
        aws_security_group.eks_cluster_security_group.id,
    ]
  }

  kubernetes_network_config {
    ip_family = "ipv4"
    #service_ipv4_cidr = "172.20.0.0/16"
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  version = var.cluster_version
  depends_on = [
    aws_iam_role.eks_role,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
  ]
}

data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.this.identity.0.oidc.0.issuer
}