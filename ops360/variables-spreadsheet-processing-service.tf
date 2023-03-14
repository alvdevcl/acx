## Spreadsheet Processing Service Configuration
variable "spreadsheet_processing_service_name" {
  type        = string
  description = "Microservice name"
  default     = "spreadsheet-processing-service"
}

variable "spreadsheet_processing_service_image" {
  type        = string
  description = "Spreadsheet Processing service image repo url"
}

variable "spreadsheet_processing_service_postgres_database" {
  type        = string
  description = "Spreadsheet-Processing-Service postgres database name"
  default     = "spsdb"
}

## AWS Secrets Manager Configuration
variable "spreadsheet_processing_service_secman_name" {
  type = string
  description = "Spreadsheet Processing Service Secrets Manager name"
  default     = "dev/ops360/spreadsheet-processing-service"
}

variable "spreadsheet_processing_service_secman_secret_entries" {
  type        = list(string)
  description = "Spreadsheet Processing Service AWS Secrets Manager Keys"
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

variable "spreadsheet_processing_service_secman_enable_keystore" {
  type        = bool
  description = "Enable Auth Keystore"
  default     = true
}

## Spreadsheet Processing Service Kubernetes Configuration
variable "spreadsheet_processing_service_replica_count" {
  type = string
  description = "Spreadsheet Processing Service pod count"
  default = "1"
}

variable "spreadsheet_processing_service_k8s_cpu_limit" {
  type        = string
  description = "Pod CPU resource limit"
  default     = "1"
}

variable "spreadsheet_processing_service_k8s_cpu_request" {
  type        = string
  description = "Pod CPU resource request"
  default     = "1"
}

variable "spreadsheet_processing_service_k8s_memory_limit" {
  type        = string
  description = "Pod memory resource limit"
  default     = "2G"
}

variable "spreadsheet_processing_service_k8s_memory_request" {
  type        = string
  description = "Pod memory resource request"
  default     = "2G"
}

## Spreadsheet Processing Service Kubernetes Secrets Store Configuration
variable "spreadsheet_processing_service_k8s_secret_name" {
  type        = string
  description = "Target k8s secret consumed by the microservice"
  default     = "spreadsheet-processing-service-secret"
}

variable "spreadsheet_processing_service_k8s_secret_store_name" {
  type        = string
  description = "Secret Manager k8s store name"
  default     = "spreadsheet-processing-service-secret-store"
}

variable "spreadsheet_processing_service_k8s_service_account_name" {
  type        = string
  description = "Service account linked to specified aws secrets document"
  default     = "spreadsheet-processing-service-sa"
}