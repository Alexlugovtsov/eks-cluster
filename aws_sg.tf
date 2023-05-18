data "aws_vpc" "this" {
  id = var.vpc_id
}
resource "aws_security_group" "eks_cluster_security_group" {
  name        = "eks-${var.cluster_name}-cluster-group"
  description = "Security group for ${var.cluster_name} cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  tags = {
    Name = "${var.cluster_name}-cluster-group"
    "dtit:sec:InfoSecClass" = "confidential"
    "dtit:sec:NetworkLayer" = "Application"
  }
}
