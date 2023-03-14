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

## Begin Services
module "auth_service" {
  source = "./services/auth-service"

  ## AWS General Configuration
  aws_region          = var.aws_region
  aws_account_id      = var.aws_account_id
  route53_base_domain = var.route53_base_domain

  ## AWS IAM Configuration
  permissions_boundary = var.permissions_boundary

  ## AWS Secrets Manager Configuration
  secman_name            = var.auth_service_secman_name
  secman_secret_entries  = var.auth_service_secman_secret_entries
  secman_enable_keystore = var.auth_service_secman_enable_keystore

  ## Multifactor Authentication Configuration
  mfa_enabled = var.auth_service_mfa_enabled

  ## General Auth Service Configuration
  image        = var.auth_service_image
  service_name = var.auth_service_name

  ## Database Configuration
  postgres_database = var.auth_service_postgres_database

  ## Kubernetes General Configuration
  k8s_namespace    = var.k8s_namespace
  eks_cluster_name = var.eks_cluster_name

  ## Kubernetes Secret Store Configuration
  k8s_secret_name          = var.auth_service_k8s_secret_name
  k8s_secret_store_name    = var.auth_service_k8s_secret_store_name
  k8s_service_account_name = var.auth_service_k8s_service_account_name

  ## Kubernetes Resource Configuration
  k8s_replica_count  = var.auth_service_replica_count
  k8s_cpu_request    = var.auth_service_k8s_cpu_request
  k8s_cpu_limit      = var.auth_service_k8s_cpu_limit
  k8s_memory_request = var.auth_service_k8s_memory_request
  k8s_memory_limit   = var.auth_service_k8s_memory_limit
}

module "bdms_service" {
  source = "./services/bdms-service"

  ## AWS General Configuration
  aws_region          = var.aws_region
  aws_account_id      = var.aws_account_id
  route53_base_domain = var.route53_base_domain

  ## AWS IAM Configuration
  permissions_boundary = var.permissions_boundary

  ## AWS Secrets Manager Configuration
  secman_name            = var.bdms_service_secman_name
  secman_secret_entries  = var.bdms_service_secman_secret_entries
  secman_enable_keystore = var.bdms_service_secman_enable_keystore

  ## General BDMS Service Configuration
  image        = var.bdms_service_image
  service_name = var.bdms_service_name

  ## Database Configuration
  postgres_database = var.bdms_service_postgres_database

  ## Kubernetes General Configuration
  k8s_namespace    = var.k8s_namespace
  eks_cluster_name = var.eks_cluster_name

  ## Kubernetes Secret Store Configuration
  k8s_secret_name          = var.bdms_service_k8s_secret_name
  k8s_secret_store_name    = var.bdms_service_k8s_secret_store_name
  k8s_service_account_name = var.bdms_service_k8s_service_account_name

  ## Kubernetes Resource Configuration
  k8s_replica_count  = var.bdms_service_replica_count
  k8s_cpu_request    = var.bdms_service_k8s_cpu_request
  k8s_cpu_limit      = var.bdms_service_k8s_cpu_limit
  k8s_memory_request = var.bdms_service_k8s_memory_request
  k8s_memory_limit   = var.bdms_service_k8s_memory_limit
}

module "bpm_admin_ui" {
  source = "./services/bpm-admin-ui"

  image = var.bpm_admin_ui_image
}

module "core_ui" {
  source = "./services/core-ui"

  image = var.core_ui_image
}

module "data_browsing_ui" {
  source = "./services/data-browsing-ui"

  image = var.data_browsing_ui_image
}

module "data_model_admin_ui" {
  source = "./services/data-model-admin-ui"

  image = var.data_model_admin_ui_image
}

module "data_sets_service" {
  source = "./services/data-sets-service"

  ## AWS General Configuration
  aws_region          = var.aws_region
  aws_account_id      = var.aws_account_id
  route53_base_domain = var.route53_base_domain

  ## AWS IAM Configuration
  permissions_boundary = var.permissions_boundary

  ## AWS Secrets Manager Configuration
  secman_name            = var.data_sets_service_secman_name
  secman_secret_entries  = var.data_sets_service_secman_secret_entries
  secman_enable_keystore = var.data_sets_service_secman_enable_keystore

  ## General DataSets Service Configuration
  image        = var.data_sets_service_image
  service_name = var.data_sets_service_name

  ## Database Configuration
  postgres_database = var.data_sets_service_postgres_database

  ## Kubernetes General Configuration
  k8s_namespace    = var.k8s_namespace
  eks_cluster_name = var.eks_cluster_name

  ## Kubernetes Secret Store Configuration
  k8s_secret_name          = var.data_sets_service_k8s_secret_name
  k8s_secret_store_name    = var.data_sets_service_k8s_secret_store_name
  k8s_service_account_name = var.data_sets_service_k8s_service_account_name

  ## Kubernetes Resource Configuration
  k8s_replica_count  = var.data_sets_service_replica_count
  k8s_cpu_request    = var.data_sets_service_k8s_cpu_request
  k8s_cpu_limit      = var.data_sets_service_k8s_cpu_limit
  k8s_memory_request = var.data_sets_service_k8s_memory_request
  k8s_memory_limit   = var.data_sets_service_k8s_memory_limit
}

module "data_view_admin_ui" {
  source = "./services/data-view-admin-ui"

  image = var.data_view_admin_image
}

module "spreadsheet_processing_service" {
  source = "./services/spreadsheet-processing-service"

  ## AWS General Configuration
  aws_region          = var.aws_region
  aws_account_id      = var.aws_account_id
  route53_base_domain = var.route53_base_domain

  ## AWS IAM Configuration
  permissions_boundary = var.permissions_boundary

  ## AWS Secrets Manager Configuration
  secman_name            = var.spreadsheet_processing_service_secman_name
  secman_secret_entries  = var.spreadsheet_processing_service_secman_secret_entries
  secman_enable_keystore = var.spreadsheet_processing_service_secman_enable_keystore

  ## General DataSets Service Configuration
  image        = var.spreadsheet_processing_service_image
  service_name = var.spreadsheet_processing_service_name

  ## Database Configuration
  postgres_database = var.spreadsheet_processing_service_postgres_database

  ## Kubernetes General Configuration
  k8s_namespace    = var.k8s_namespace
  eks_cluster_name = var.eks_cluster_name

  ## Kubernetes Secret Store Configuration
  k8s_secret_name          = var.spreadsheet_processing_service_k8s_secret_name
  k8s_secret_store_name    = var.spreadsheet_processing_service_k8s_secret_store_name
  k8s_service_account_name = var.spreadsheet_processing_service_k8s_service_account_name

  ## Kubernetes Resource Configuration
  k8s_replica_count  = var.spreadsheet_processing_service_replica_count
  k8s_cpu_request    = var.spreadsheet_processing_service_k8s_cpu_request
  k8s_cpu_limit      = var.spreadsheet_processing_service_k8s_cpu_limit
  k8s_memory_request = var.spreadsheet_processing_service_k8s_memory_request
  k8s_memory_limit   = var.spreadsheet_processing_service_k8s_memory_limit
}

resource "aws_route53_record" "ops360" {
  zone_id = var.route53_hosted_zone_id
  name    = "ops360"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_ingress_v1.alb.status.0.load_balancer.0.ingress.0.hostname]
}
