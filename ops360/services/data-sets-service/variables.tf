## AWS General Configuration
variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
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

## AWS Secrets Manager Configuration
variable "secman_name" {
  type        = string
  description = "Secret Manager name storing data-sets-service specific secrets"
}

variable "secman_secret_entries" {
  type        = list(string)
  description = "Auth Service AWS Secrets Manager Keys"
}

variable "secman_enable_keystore" {
  type        = bool
  description = "Enable Auth Keystore"
}

## Kubernetes Secrets Store Configuration
variable "k8s_secret_name" {
  type        = string
  description = "Target k8s secret consumed by the microservice"
}

variable "k8s_secret_store_name" {
  type        = string
  description = "Secret Manager k8s store name"
}

variable "k8s_service_account_name" {
  type        = string
  description = "Secret Manager mapped k8s service account name"
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

## DataSets Service Configuration
variable "service_name" {
  type        = string
  description = "Microservice name"
}

variable "postgres_database" {
  type        = string
  description = "Datasets service postgres database name"
}

variable "image" {
  type        = string
  description = "Service image url"
}

## DataSets Kubernetes Configuration
variable "k8s_replica_count" {
  type = string
  description = "DataSets Service pod count"
}

variable "k8s_cpu_limit" {
  type        = string
  description = "Pod CPU resource limit"
}

variable "k8s_memory_limit" {
  type        = string
  description = "Pod memory resource limit"
}

variable "k8s_cpu_request" {
  type        = string
  description = "Pod CPU resource request"
}

variable "k8s_memory_request" {
  type        = string
  description = "Pod memory resource request"
}
