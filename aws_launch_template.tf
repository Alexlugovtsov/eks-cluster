resource "aws_launch_template" "worker_nodes" {
  name        = "eks-${var.cluster_name}-launch-template"
  description = "Worker nodes Launch Template for ${var.cluster_name} cluster"
  instance_type = var.instance_type

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 100
    }
  }

  vpc_security_group_ids = [
    aws_security_group.worker_nodes_main.id,
  ]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_security_group.worker_nodes_main,
  ]
}