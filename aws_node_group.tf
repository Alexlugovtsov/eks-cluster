data "aws_iam_policy_document" "worker_node_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "worker_role" {
  name        = "eks-${var.cluster_name}-worker-role"
  description = "Worker role for EKS ${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.worker_node_assume_policy.json
}
resource "aws_iam_role_policy_attachment" "worker_role_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ])

  role       = aws_iam_role.worker_role.name
  policy_arn = each.value
}
resource "aws_eks_node_group" "managed_group" {
  ami_type        = "BOTTLEROCKET_x86_64"
  cluster_name    = var.cluster_name
  node_group_name = "eks-${var.cluster_name}-worker-nodes"
  node_role_arn   = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-${var.cluster_name}-worker-role"
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = var.instance_count
    max_size     = var.max_size
    min_size     = var.min_size
  }

  launch_template {
    name    = aws_launch_template.worker_nodes.name
    version = "1"
  }

  depends_on = [
    kubernetes_config_map.aws_auth_configmap,
    aws_security_group.worker_nodes_main,
  ]

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config
    ]
  }
}
resource "aws_security_group" "worker_nodes_main" {
  name        = "eks-${var.cluster_name}-worker-nodes-main"
  description = "Security group for ${var.cluster_name} worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups  = [aws_security_group.eks_cluster_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups  = [aws_security_group.eks_cluster_security_group.id]
  }

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    Name = "eks-${var.cluster_name}-worker-nodes"
    "dtit:sec:InfoSecClass" = "confidential"
    "dtit:sec:NetworkLayer" = "Application"
  }
}