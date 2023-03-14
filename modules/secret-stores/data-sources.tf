data "aws_eks_cluster" "ops360" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "ops360" {
  name = var.eks_cluster_name
}

data "aws_secretsmanager_secret_version" "secman" {
  secret_id = var.secman_name
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}