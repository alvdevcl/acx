data "aws_eks_cluster" "ops360" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "ops360" {
  name = var.eks_cluster_name
}

data "kubernetes_ingress_v1" "alb" {
  metadata {
    name      = "core-ui-ingress"
    namespace = var.k8s_namespace
  }

  depends_on = [
    module.core_ui
  ]
}
