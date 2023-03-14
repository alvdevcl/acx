terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17.1"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_aws_region
}

data "aws_subnets" "eks" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_vpc" "ops360" {
  id = var.vpc_id
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = var.vpc_id
}

#------------------------------------------------------------------
# Create Secrets Manager service vpc endpoint
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

#------------------------------------------------------------------
# Create Aurora Postgres cluster using CG supplied module
module "aurora-postgresql" {
  source = "git::https://github.com/open-itg/terraform-aws-aurora-postgresql.git?ref=4.0.8"

  atm_id      = var.atm_id
  cost_centre = var.cost_center
  ppmc_id     = var.ppmc_id
  toc         = var.toc
  exp_date    = var.exp_date
  env         = var.env
  sd_period   = var.sd_period
  backup      = "not-required-sbx"

  app_name                     = "ops360rds"
  aws_region                   = var.aws_region
  primary_vpc_filter           = data.aws_vpc.ops360.tags["Name"]
  db_name                      = "ops360db"
  maintenance_window           = "sun:04:00-sun:05:00"
  private_hosted_zone_name     = var.base_domain
  cluster_family               = "aurora-postgresql13"
  engine_version               = "13.3"
  primary_subnet_ids           = data.aws_subnets.eks.ids
  primary_secman_vpc_end_point = aws_vpc_endpoint.secman.id
  deletion_protection          = false

  providers = {
    aws.secondary = aws.secondary
  }
}
