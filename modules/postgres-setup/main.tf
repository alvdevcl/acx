terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.0"
    }
  }
}

resource "random_password" "postgres" {
  length  = 16
  special = false
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "null_resource" "setup_postgres" {
  triggers = {
    host = var.postgres_endpoint
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/scripts"
    command     = "./postgres.sh apply ${var.postgres_service_database} ${local.postgres_service_username} ${local.postgres_service_password}"

    environment = {
      PGHOST           = var.postgres_endpoint
      PGPORT           = var.postgres_port
      PGUSER           = var.postgres_user
      PGPASSWORD       = var.postgres_password
      PGDATABASE       = var.postgres_database
      PGSSLMODE        = var.postgres_ssl_mode
      PGSSLCOMPRESSION = var.postgres_ssl_compression
      PGSSLROOTCERT    = var.postgres_ssl_root_cert
    }
  }
}

locals {
  postgres_service_password = random_password.postgres.result
  postgres_service_username = "${var.postgres_service_database}_user"
  postgres_env_vars = {
    POSTGRES_HOST     = var.postgres_endpoint
    POSTGRES_PORT     = var.postgres_port
    POSTGRES_DATABASE = var.postgres_service_database
    POSTGRES_USERNAME = local.postgres_service_username
    POSTGRES_PASSWORD = local.postgres_service_password
  }
}
