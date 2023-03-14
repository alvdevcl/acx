provider "aws" {
  region = var.region
}

locals {
  id = "${var.stage}-${var.project_name}"
}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket         = "codep-tfeks-ip-172-31-94-152-1676633921776721362"
    key            = "terraform/terraform_locks_app_eks.tfstate"
    region         = "us-east-1"
   }
}


###############################################################################
# Secrets Manager VPC endpoint
###############################################################################
resource "aws_vpc_endpoint" "secman" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.us-east-1.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = false
  auto_accept         = true

  security_group_ids = [
    data.aws_security_group.default.id
  ]

  subnet_ids = data.aws_subnets.eks.ids

  tags = {
    Name = "Ops360 Secrets Manager VPC Endpoint"
  }
}

###############################################################################
# DB Subnet Group
###############################################################################

resource "aws_db_subnet_group" "ops360-db" {
  name       = "ops360-db"
  subnet_ids = data.terraform_remote_state.eks.outputs.public_subnets

  tags = {
    Name = "ops360-db"
  }
}

###############################################################################
# RDS Security Group
###############################################################################

resource "aws_security_group" "rds_sg" {
  name   = "ops360db_rds"
  vpc_id = data.terraform_remote_state.eks.outputs.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ops360db_rds"
  }
}


resource "aws_security_group" "secrets_manager_endpoint_sg" {
  name        = "ops360-sm-endpoint-sg"
  description = "Secrets Manager VPC endpoint SG"
  vpc_id      = data.terraform_remote_state.eks.outputs.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ssm_parameter" "db_security_group_id" {
  name        = "/${var.stage}/${var.project_name}/database/security_group_id"
  description = "The RDS security group ID"
  type        = "String"
  value       = aws_security_group.rds_sg.id
}

resource "aws_db_parameter_group" "ops360-db" {
  name   = "ops360-db"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "ops360-db" {
  identifier              = "ops360-db"
  instance_class          = "db.t3.micro"
  db_name              = "ops360db"
  allocated_storage       = 10
  backup_retention_period   = 1
  apply_immediately       = true
  engine                  = "postgres"
  engine_version          = "14.1"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.ops360-db.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  parameter_group_name    = aws_db_parameter_group.ops360-db.name
  publicly_accessible     = true
  skip_final_snapshot     = true
}



###############################################################################
# Store secret in Secrets Manager
###############################################################################

resource "aws_secretsmanager_secret" "secman" {
  name        = "ops/acx/database/secret"
  description = "RDS master database secret"
}

resource "aws_secretsmanager_secret_version" "secman" {
  secret_id = aws_secretsmanager_secret.secman.id
  secret_string = jsonencode(
    {
      username            = aws_db_instance.ops360-db.username
      password            = aws_db_instance.ops360-db.password
      engine              = "postgres"
      host                = aws_db_instance.ops360-db.address
      Identifier          = aws_db_instance.ops360-db.identifier
      database_name       = aws_db_instance.ops360-db.db_name
      port                = aws_db_instance.ops360-db.port
    }
  )
}

resource "aws_ssm_parameter" "db_secret" {
  name        = "/${var.stage}/${var.project_name}/database/secret"
  description = "The secrets manager secret ARN for RDS secret"
  type        = "String"
  value       = aws_secretsmanager_secret.secman.arn
}
