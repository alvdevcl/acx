provider "aws" {
  region = var.aws_region
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.ops360.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.ops360.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.ops360.token
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.ops360.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.ops360.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.ops360.token
}