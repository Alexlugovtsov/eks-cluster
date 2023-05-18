resource "aws_security_group" "alb" {
  name        = "${var.cluster_name}-alb-sg"
  description = "Security group for aws_lb of ${var.cluster_name} cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "ingress.k8s.aws/resource" = "ManagedLBSecurityGroup"
    "ingress.k8s.aws/stack"    = var.cluster_name
    "elbv2.k8s.aws/cluster"    = var.cluster_name
    "dtit:sec:InfoSecClass" = "confidential"
    "dtit:sec:NetworkLayer" = "Application"
  }
}

# ~3 minutes to create
resource "aws_lb" "default" {
  name               = "${var.cluster_name}-lb" # (Required) The name of the load balancer. This name must be unique per region per account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen.
  internal           = false # (Optional) If true, the LB will be internal.
  load_balancer_type = "application" # (Optional) The type of load balancer. The default is application
  security_groups    = [aws_security_group.alb.id] # (Required) A list of security group IDs to assign to the load balancer.
  subnets            = var.public_subnets # (Required) A list of subnet IDs to attach to the load balancer.
  drop_invalid_header_fields = true  # PSA ALB Req 5

  tags = {
    "ingress.k8s.aws/stack"    = var.cluster_name
    "elbv2.k8s.aws/cluster"    = var.cluster_name
    "ingress.k8s.aws/resource" = "LoadBalancer"
  }
  lifecycle {
    ignore_changes = [
      security_groups # Let the aws-load-balancer-controller manage the security groups for us
    ]
  }
}
