output "username" {
  value       = local.postgres_service_password
  description = "Generated Ops360 Service Postgres Username"
}

output "password" {
  value       = local.postgres_service_password
  description = "Generated Ops360 Service Postgres Password"
  sensitive   = true
}

output "database" {
  value       = var.postgres_service_database
  description = "Ops360 Service Postgres Database"
}

output "host" {
  value       = var.postgres_endpoint
  description = "Postgres Host"
}

output "port" {
  value       = var.postgres_port
  description = "Postgres Port"
}

output "pg_env_vars" {
  value       = local.postgres_env_vars
  description = "JSON containing postgres host and credentials"
}
