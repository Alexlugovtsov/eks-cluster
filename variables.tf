variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}
variable "environment_name" {
  description = "Environment name"
  type        = string
}
variable "region" {
  description = "AWS region"
  type        = string
}
variable "hosted_zone" {
  description = "DNS Hosted Zone"
  type        = string
}
variable "cluster_version" {
  description = "Kubernetes version"
  type        = number
}
variable "min_size" {
  description = "Min Workers Count"
  type        = number
}
variable "max_size" {
  description = "Max Workers Count"
  type        = number
}
variable "instance_count" {
  description = "Desired Workers Count"
  type        = number
}
variable "instance_type" {
  description = "EKS node instance type"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID to attach the EKS cluster to"
  type        = string
}
variable "public_subnets" {
  description = "Public Subnets for the EKS cluster"
  type        = list
}
variable "private_subnets" {
  description = "Private Subnets for the EKS worker nodes"
  type        = list
}
variable "Admin_username" {
  description = "Admin Username"
  type        = string
}
variable "teams" {
  description = "teams List"
  type        = list
}
