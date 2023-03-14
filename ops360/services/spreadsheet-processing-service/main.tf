terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.14.0"
    }
  }
}

# Setup Secret Manager plugin
# Creates ExternalSecret, SecretStore and Secret
module "secret_store" {
  source = "../../../modules/secret-stores"

  ## AWS General Configuration
  aws_region               = var.aws_region
  aws_account_id           = var.aws_account_id

  ## AWS IAM Configuration
  permissions_boundary     = var.permissions_boundary

  ## AWS Secrets Manager Configuration
  secman_name              = var.secman_name
  secman_enable_keystore   = var.secman_enable_keystore
  secman_secret_entries    = var.secman_secret_entries

  ## Kubernetes General Configuration
  eks_cluster_name         = var.eks_cluster_name
  k8s_namespace            = var.k8s_namespace
  service_name             = var.service_name

  ## Kubernetes Secrets Store Configuration
  k8s_service_account_name = var.k8s_service_account_name
  k8s_secret_name          = var.k8s_secret_name
  k8s_secret_store_name    = var.k8s_secret_store_name
}

# Install kuberenetes secrets
resource "helm_release" "spreadsheet_processing_service" {
  name              = var.service_name
  chart             = "../helm/spreadsheet-processing-service"
  dependency_update = true
  create_namespace  = true
  reuse_values      = true
  namespace         = var.k8s_namespace

  set {
    name  = "image"
    value = var.image
  }

  set {
    name  = "awsRegion"
    value = var.aws_region
  }

  set {
    name  = "namespace"
    value = var.k8s_namespace
  }

  set {
    name  = "routeHost"
    value = var.route53_base_domain
  }

  set {
    name  = "keystoreEnabled"
    value = var.secman_enable_keystore
    type  = "auto"
  }

  set {
    name  = "serviceAccountName"
    value = module.secret_store.k8s_service_account_name
  }

  set {
    name  = "serviceAccountRoleArn"
    value = module.secret_store.service_account_iam_role_arn
  }

  set {
    name  = "secmanName"
    value = var.secman_name
  }

  set {
    name  = "secretName"
    value = module.secret_store.k8s_secret_name
  }

  set {
    name  = "serviceCpu"
    value = var.k8s_cpu_limit
  }

  set {
    name  = "serviceMemory"
    value = var.k8s_memory_limit
  }
}
