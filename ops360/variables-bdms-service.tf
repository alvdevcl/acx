## BDMS Service Configuration
variable "bdms_service_name" {
  type        = string
  description = "Microservice name"
  default     = "bdms-service"
}

variable "bdms_service_image" {
  type        = string
  description = "bdms service image repo url"
}

variable "bdms_service_postgres_database" {
  type        = string
  description = "BDMS-Service postgres database name"
  default     = "bdmsdb"
}

## AWS Secrets Manager Configuration
variable "bdms_service_secman_name" {
  type = string
  description = "BDMS Service Secrets Manager name"
  default     = "dev/ops360/bdms-service"
}

variable "bdms_service_secman_secret_entries" {
  type        = list(string)
  description = "BDMS Service AWS Secrets Manager Keys"
  default = [
    "KEYSTORE_KEY_ALIAS",
    "KEYSTORE_KEY_PASSWORD",
    "KEYSTORE_PASSWORD",
    "KEYSTORE_SIG_ALG",
    "ORACLE_USERNAME",
    "ORACLE_PASSWORD",
    "ORACLE_DATABASE",
    "ORACLE_HOST",
    "ORACLE_PORT",
    "PRIME_USERNAME",
    "PRIME_PASSWORD",
    "PRIME_INSTALLATION",
    "PRIME_HOST",
    "POSTGRES_USERNAME",
    "POSTGRES_PASSWORD",
    "POSTGRES_DATABASE",
    "POSTGRES_HOST",
    "POSTGRES_PORT",
    "PLAY_HTTP_SECRET_KEY"
  ]
}

variable "bdms_service_secman_enable_keystore" {
  type        = bool
  description = "Enable bdms Keystore"
  default     = true
}

## bdmsService Kubernetes Configuration
variable "bdms_service_replica_count" {
  type = string
  description = "bdms Service pod count"
  default = "1"
}

variable "bdms_service_k8s_cpu_limit" {
  type        = string
  description = "Pod CPU resource limit"
  default     = "1"
}

variable "bdms_service_k8s_cpu_request" {
  type        = string
  description = "Pod CPU resource request"
  default     = "1"
}

variable "bdms_service_k8s_memory_limit" {
  type        = string
  description = "Pod memory resource limit"
  default     = "2G"
}

variable "bdms_service_k8s_memory_request" {
  type        = string
  description = "Pod memory resource request"
  default     = "2G"
}

## bdmsService Kubernetes Secrets Store Configuration
variable "bdms_service_k8s_secret_name" {
  type        = string
  description = "Target k8s secret consumed by the microservice"
  default     = "bdms-service-secret"
}

variable "bdms_service_k8s_secret_store_name" {
  type        = string
  description = "Secret Manager k8s store name"
  default     = "bdms-service-secret-store"
}

variable "bdms_service_k8s_service_account_name" {
  type        = string
  description = "Service account linked to specified aws secrets document"
  default     = "bdms-service-sa"
}