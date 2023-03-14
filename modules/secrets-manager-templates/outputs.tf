output "secman_arn" {
  value       = aws_secretsmanager_secret_version.ops360-service-entries.arn
  description = "AWS Secret Manager resource arn"
}

output "secman_secret_id" {
  value       = aws_secretsmanager_secret_version.ops360-service-entries.id
  description = "AWS Secret Manager secret id"
}
