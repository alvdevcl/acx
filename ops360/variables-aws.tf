## AWS General Configuration
variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "route53_hosted_zone_id" {
  type        = string
  description = "Route53 Hosted Zone ID"
}

variable "route53_base_domain" {
  type        = string
  description = "Hostname used by the alb ingress"
}

## AWS IAM Configuration
variable "permissions_boundary" {
  type        = string
  description = "IAM Permissions Boundary used to create the secret policy and role"
}

## Kubernetes General Configuration
variable "eks_cluster_name" {
  type        = string
  description = "EKS Cluster Name"
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace"
}