## Auth Service Configuration
variable "auth_service_name" {
  type        = string
  description = "Microservice name"
  default     = "auth-service"
}

variable "auth_service_image" {
  type        = string
  description = "Authentication service image repo url"
}

variable "auth_service_postgres_database" {
  type        = string
  description = "Auth-Service postgres database name"
  default     = "authdb"
}

## AWS Secrets Manager Configuration
variable "auth_service_secman_name" {
  type = string
  description = "Auth Service Secrets Manager name"
  default     = "dev/ops360/auth-service"
}

variable "auth_service_secman_secret_entries" {
  type        = list(string)
  description = "Auth Service AWS Secrets Manager Keys"
  default = [
    "KEYSTORE_KEY_ALIAS",
    "KEYSTORE_KEY_PASSWORD",
    "KEYSTORE_PASSWORD",
    "KEYSTORE_SIG_ALG",
    "POSTGRES_USERNAME",
    "POSTGRES_PASSWORD",
    "POSTGRES_DATABASE",
    "POSTGRES_HOST",
    "POSTGRES_PORT",
    "PLAY_HTTP_SECRET_KEY"
  ]
}

variable "auth_service_secman_enable_keystore" {
  type        = bool
  description = "Enable Auth Keystore"
  default     = true
}

# Multifactor Authentication Configuration
variable "auth_service_mfa_enabled" {
  type        = bool
  description = "Enable Multifactor Authentication"
  default     = false
}

variable "auth_service_mfa_auth_endpoint" {
  type        = string
  description = "MFA authentication endpoint"
  default     = ""
}

variable "auth_service_mfa_logout_endpoint" {
  type        = string
  description = "MFA logout endpoint"
  default     = ""
}

variable "auth_service_mfa_logout_redirect_endpoint" {
  type        = string
  description = "MFA logout redirect endpoint"
  default     = ""
}

variable "auth_service_mfa_redirect_endpoint" {
  type        = string
  description = "MFA redirect endpoint"
  default     = ""
}

variable "auth_service_mfa_ops360_endpoint" {
  type        = string
  description = "MFA ops360 endpoint"
  default     = ""
}

variable "auth_service_mfa_token_endpoint" {
  type        = string
  description = "MFA token"
  default     = ""
}

## AuthService Kubernetes Configuration
variable "auth_service_replica_count" {
  type = string
  description = "Auth Service pod count"
  default = "1"
}

variable "auth_service_k8s_cpu_limit" {
  type        = string
  description = "Pod CPU resource limit"
  default     = "1"
}

variable "auth_service_k8s_cpu_request" {
  type        = string
  description = "Pod CPU resource request"
  default     = "1"
}

variable "auth_service_k8s_memory_limit" {
  type        = string
  description = "Pod memory resource limit"
  default     = "2G"
}

variable "auth_service_k8s_memory_request" {
  type        = string
  description = "Pod memory resource request"
  default     = "2G"
}

## AuthService Kubernetes Secrets Store Configuration
variable "auth_service_k8s_secret_name" {
  type        = string
  description = "Target k8s secret consumed by the microservice"
  default     = "auth-service-secret"
}

variable "auth_service_k8s_secret_store_name" {
  type        = string
  description = "Secret Manager k8s store name"
  default     = "auth-service-secret-store"
}

variable "auth_service_k8s_service_account_name" {
  type        = string
  description = "Service account linked to specified aws secrets document"
  default     = "auth-service-sa"
}