data "aws_eks_cluster" "ops360" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "ops360" {
  name = var.eks_cluster_name
}