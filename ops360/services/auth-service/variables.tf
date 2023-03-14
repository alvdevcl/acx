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
  description = "Auth Service AWS Secret Document Name"
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
  description = "Service account linked to specified aws secrets document"
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

## Auth Service Configuration
variable "service_name" {
  type        = string
  description = "Microservice name"
}

variable "postgres_database" {
  type        = string
  description = "Auth-Service postgres database name"
}

variable "image" {
  type        = string
  description = "Service image url"
}

# Multifactor Authentication Configuration
variable "mfa_enabled" {
  type        = bool
  description = "Enable Multifactor Authentication"
  default     = false
}

variable "mfa_auth_endpoint" {
  type        = string
  description = "MFA authentication endpoint"
  default     = ""
}

variable "mfa_logout_endpoint" {
  type        = string
  description = "MFA logout endpoint"
  default     = ""
}

variable "mfa_logout_redirect_endpoint" {
  type        = string
  description = "MFA logout redirect endpoint"
  default     = ""
}

variable "mfa_redirect_endpoint" {
  type        = string
  description = "MFA redirect endpoint"
  default     = ""
}

variable "mfa_ops360_endpoint" {
  type        = string
  description = "MFA ops360 endpoint"
  default     = ""
}

variable "mfa_token_endpoint" {
  type        = string
  description = "MFA token"
  default     = ""
}

## AuthService Kubernetes Configuration
variable "k8s_replica_count" {
  type = string
  description = "Auth Service pod count"
  default = "1"
}

variable "k8s_cpu_limit" {
  type        = string
  description = "Pod CPU resource limit"
}

variable "k8s_cpu_request" {
  type        = string
  description = "Pod CPU resource request"
}

variable "k8s_memory_limit" {
  type        = string
  description = "Pod memory resource limit"
}

variable "k8s_memory_request" {
  type        = string
  description = "Pod memory resource request"
}