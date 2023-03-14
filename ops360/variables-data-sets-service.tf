## data_sets Service Configuration
variable "data_sets_service_name" {
  type        = string
  description = "Microservice name"
  default     = "data-sets-service"
}

variable "data_sets_service_image" {
  type        = string
  description = "DataSets service image repo url"
}

variable "data_sets_service_postgres_database" {
  type        = string
  description = "data_sets-Service postgres database name"
  default     = "datasetsdb"
}

## AWS Secrets Manager Configuration
variable "data_sets_service_secman_name" {
  type = string
  description = "DataSets Service Secrets Manager name"
  default     = "dev/ops360/data-sets-service"
}

variable "data_sets_service_secman_secret_entries" {
  type        = list(string)
  description = "DataSets Service AWS Secrets Manager Keys"
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

variable "data_sets_service_secman_enable_keystore" {
  type        = bool
  description = "Enable Authentication Keystore"
  default     = true
}

## data_setsService Kubernetes Configuration
variable "data_sets_service_replica_count" {
  type = string
  description = "DataSets Service pod count"
  default = "1"
}

variable "data_sets_service_k8s_cpu_limit" {
  type        = string
  description = "Pod CPU resource limit"
  default     = "1"
}

variable "data_sets_service_k8s_cpu_request" {
  type        = string
  description = "Pod CPU resource request"
  default     = "1"
}

variable "data_sets_service_k8s_memory_limit" {
  type        = string
  description = "Pod memory resource limit"
  default     = "2G"
}

variable "data_sets_service_k8s_memory_request" {
  type        = string
  description = "Pod memory resource request"
  default     = "2G"
}

## data_setsService Kubernetes Secrets Store Configuration
variable "data_sets_service_k8s_secret_name" {
  type        = string
  description = "Target k8s secret consumed by the microservice"
  default     = "data-sets-service-secret"
}

variable "data_sets_service_k8s_secret_store_name" {
  type        = string
  description = "Secret Manager k8s store name"
  default     = "data-sets-service-secret-store"
}

variable "data_sets_service_k8s_service_account_name" {
  type        = string
  description = "Service account linked to specified aws secrets document"
  default     = "data-sets-service-sa"
}