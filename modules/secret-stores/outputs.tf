output "k8s_service_account_name" {
  value       = var.k8s_service_account_name
  description = "K8s service account name"
}

output "k8s_secret_name" {
  value       = var.k8s_secret_name
  description = "K8s secret name used by deployments"
}

output "service_account_iam_role_arn" {
  value       = aws_iam_role.secrets_role.arn
  description = "AWS IAM role contianing secrets permissions"
}
