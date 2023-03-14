## AWS General Configuration
variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

## AWS IAM Configuration
variable "permissions_boundary" {
  type        = string
  description = "IAM Permissions Boundary used to create the secret policy and role"
}

## AWS Secrets Manager Configuration
variable "secman_name" {
  type        = string
  description = "AWS Secret Manager name"
}

variable "secman_secret_entries" {
  type        = list(string)
  description = "AWS Secret Manager key names"
}

variable "secman_enable_keystore" {
  type        = bool
  description = "Enable Java Keystore"
  default     = false
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

variable "service_name" {
  type        = string
  description = "AWS or microservice name"
}

## Kubernetes Secrets Store Configuration
variable "k8s_service_account_name" {
  type        = string
  description = "Secret Manager mapped k8s service account name"
}

variable "k8s_secret_name" {
  type        = string
  description = "Target k8s secret consumed by the microservice"
}

variable "k8s_secret_store_name" {
  type        = string
  description = "Secret Manager k8s store name"
}