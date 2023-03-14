terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
  }
}

resource "aws_secretsmanager_secret" "ops360-service" {
  name = var.secret_manager_name
}

resource "aws_secretsmanager_secret_version" "ops360-service-entries" {
  secret_id     = aws_secretsmanager_secret.ops360-service.id
  secret_string = jsonencode({ for i, v in var.secman_secret_entries : v.key => v.value })
}
