variable "postgres_endpoint" {
  type        = string
  description = "Amazon RDS Postgres Endpoint"
}

variable "postgres_port" {
  type        = number
  description = "Amazon RDS Postgres Port"
}

variable "postgres_user" {
  type        = string
  description = "Amazon RDS Postges Username"
  sensitive   = true
}

variable "postgres_password" {
  type        = string
  description = "Amazon RDS Postges Password"
  sensitive   = true
}

variable "postgres_database" {
  type        = string
  description = "Amazon RDS Postges Database"
}

variable "postgres_ssl_mode" {
  type        = string
  description = "Postgres connection SSL mode"
  default     = "prefer"
}

variable "postgres_ssl_compression" {
  type        = bool
  description = "Enable/Disable Postgres connection compression"
  default     = false
}

variable "postgres_ssl_root_cert" {
  type        = string
  description = "Amazon RDS root certificate"
  default     = "rds-ca-2019-root.pem"
}

variable "postgres_service_database" {
  type        = string
  description = "Ops360 database name"
}
