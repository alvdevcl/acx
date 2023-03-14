terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.14.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }
}

resource "aws_iam_policy" "secrets_policy" {
  name        = "${var.service_name}-secrets-policy"
  description = "Ops360 ${var.service_name} secrets manager access policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ],
        "Resource" : ["${data.aws_secretsmanager_secret_version.secman.arn}"]
      },
      {
        "Sid" : "ToAllowDecryption",
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt",
          "kms:DescribeKey"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "aws:PrincipalOrgID" : "o-g7jjwzrr1z"
          }
        }
      }
    ]
  })

  tags = {
    "service-account" = var.k8s_service_account_name
  }
}

resource "aws_iam_role" "secrets_role" {
  name                 = "${var.service_name}-secrets-role"
  permissions_boundary = var.permissions_boundary

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${var.aws_account_id}:oidc-provider/${local.oidc_output}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${local.oidc_output}:sub" : "system:serviceaccount:${var.k8s_namespace}:${var.k8s_service_account_name}",
            "${local.oidc_output}:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    "service-account" = var.k8s_service_account_name
  }
}
#------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "attach_cluster_autoscaler_policy" {
  role       = aws_iam_role.secrets_role.name
  policy_arn = aws_iam_policy.secrets_policy.arn
}

locals {
  oidc_output    = trimprefix(data.aws_eks_cluster.ops360.identity[0].oidc[0].issuer, "https://")
  aws_account_id = data.aws_caller_identity.current.account_id
}

# Install kuberenetes secrets
resource "helm_release" "secrets-store" {
  name              = "${var.service_name}-secman-config"
  chart             = "../helm/secret-stores"
  dependency_update = true
  create_namespace  = true
  reuse_values      = true
  namespace         = var.k8s_namespace

  values = [yamlencode({ "secman_secret_entries" : var.secman_secret_entries })]

  set {
    name  = "keystoreEnabled"
    value = var.secman_enable_keystore
  }

  set {
    name  = "awsRegion"
    value = var.aws_region
  }

  set {
    name  = "namespace"
    value = var.k8s_namespace
  }

  set {
    name  = "secman_name"
    value = var.secman_name
  }

  set {
    name  = "secretName"
    value = var.k8s_secret_name
  }

  set {
    name  = "secretStoreName"
    value = var.k8s_secret_store_name
  }

  set {
    name  = "serviceAccountName"
    value = var.k8s_service_account_name
  }

  set {
    name  = "serviceAccountRoleArn"
    value = aws_iam_role.secrets_role.arn
  }
}
