output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.this.name
}
output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = aws_eks_cluster.this.endpoint
}
output "cluster_id" {
  description = "The EKS cluster ID"
  value       = aws_eks_cluster.this.cluster_id
}