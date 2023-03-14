terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.34.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.14.0"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region = var.aws_region
  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
}
locals {
  tags = {
    created-by = "eks-workshop-v2"
    env        = local.environment_name
  }

  prefix           = "eks-workshop"
  environment_name = var.environment_suffix == "" ? local.prefix : "${local.prefix}-${var.environment_suffix}"
  shell_role_name  = "${local.environment_name}-shell-role"
  map_roles = [for i, r in var.eks_role_arns : {
    rolearn  = r
    username = "additional${i}"
    groups   = ["system:masters"]
  }]
}
#------------------------------------------------------------------
# Create the EKS Cluster using Capital Group supplied modules
module "control-plane" {
  source = "../modules/control-plane"

  eks_cluster_name     = var.eks_cluster_name
  subnet_ids           = var.subnet_ids
  kms_key_arn          = var.kms_key_arn
  permissions_boundary = var.permissions_boundary
  kubernetes_version   = var.kubernetes_version
  tags                 = var.tags

  #VPC CNI Add-On
  vpc_cni_addon_version     = data.aws_eks_addon_version.latest["vpc-cni"].version
  vpc_cni_resolve_conflicts = var.vpc_cni_resolve_conflicts
}

data "aws_eks_addon_version" "latest" {
  for_each = toset(["vpc-cni"])
  addon_name = each.value
  kubernetes_version = var.kubernetes_version
  most_recent = true
}
module "node-group-1" {
  source = "../modules/node-group-1"

  cluster_name         = module.control-plane.eks_name
  node_group_name      = var.node_group_name
  subnet_ids           = var.subnet_ids
  desired_size         = var.desired_size
  max_size             = var.max_size
  min_size             = var.min_size
  kubernetes_version   = var.kubernetes_version
  permissions_boundary = var.permissions_boundary
  tags                 = var.tags
  vpc_id               = var.vpc_id
  instance_types       = [var.node_instance_type]
}

#------------------------------------------------------------------
# Tag the private subnets used by EKS with the following tags
#
# kubernetes.io/cluster/cluster-name: shared
# kubernetes.io/role/internal-elb: 1
resource "aws_ec2_tag" "eks_private_subnet_cluster_name_tag" {
  for_each    = toset(var.subnet_ids)
  resource_id = each.key
  key         = "kubernetes.io/cluster/${var.eks_cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "eks_private_subnet_internal_elb_tag" {
  for_each    = toset(var.subnet_ids)
  resource_id = each.key
  key         = "kubernetes.io/role/internal-elb"
  value       = 1
}
#------------------------------------------------------------------

#------------------------------------------------------------------
# Login to kubernetes
# TODO: Set the host, cluster_ca_certificate and token into a local variable
data "aws_eks_cluster" "ops360" {
  name = module.control-plane.eks_name
}

data "aws_eks_cluster_auth" "ops360" {
  name = module.control-plane.eks_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.ops360.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.ops360.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.ops360.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.ops360.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.ops360.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.ops360.token
  }
}
#------------------------------------------------------------------


#------------------------------------------------------------------
# Install/upgrade the following addons:
# - External Secrets Store (AWS Secrets Manager plugin)
# - coredns
# - kube-proxy
# - aws-load-balancer-controller (alb)
#
# TODO: Move the addon_versions into variables
# module "eks_infra_components" {
#   source = "../modules/eks_infra_components"

#   eks_cluster_name = module.control-plane.eks_name
#   base_domain      = var.base_domain

#   secrets_store_csi_enable     = false
#   cluster_autoscaler_image_tag = "1.23.10"

#   aws_ebs_csi_driver_enable = false
# }

# module "eks-infra-common-components" {
#   source = "../modules/eks-infra-common-components"

#   eks_cluster_name                    = module.control-plane.eks_name
#   aws_load_balancer_controller_enable = var.aws_load_balancer_controller_enable
#   permissions_boundary                = var.permissions_boundary

#   vpc_id                           = var.vpc_id
#   coredns_addon_version            = "v1.8.7-eksbuild.3"
#   kube_proxy_addon_version         = "v1.23.15-eksbuild.1"
#   velero_backup_enable             = false
#   velero_s3_kms_key_arn            = ""
#   external_secrets_operator_enable = true
# }
#------------------------------------------------------------------
locals {
  ebs_csi_blocker = try(module.eks_blueprints_kubernetes_addons.aws_ebs_csi_driver.release_metadata.metadata.status, "")
}

resource "random_string" "fluentbit_log_group" {
  length  = 6
  special = false
}

module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.16.0//modules/kubernetes-addons"

  # depends_on = [
  #   aws_eks_addon.vpc_cni
  # ]

  eks_cluster_id = module.control-plane.eks_name

  enable_karpenter                       = true
  enable_aws_node_termination_handler    = true
  enable_aws_load_balancer_controller    = true
  enable_cluster_autoscaler              = false
  enable_metrics_server                  = true
  enable_kubecost                        = true
  enable_amazon_eks_adot                 = false
  enable_aws_efs_csi_driver              = true
  enable_aws_for_fluentbit               = false
  enable_self_managed_aws_ebs_csi_driver = false
  enable_crossplane                      = false
  enable_argocd                          = false

  self_managed_aws_ebs_csi_driver_helm_config = {
    set = [{
      name  = "node.tolerateAllTaints"
      value = "true"
      },
      {
        name  = "controller.replicaCount"
        value = 1
      },
      {
        name  = "controller.nodeSelector.workshop-system"
        value = "yes"
        type  = "string"
      },
      {
        name  = "controller.tolerations[0].key"
        value = "systemComponent"
        type  = "string"
      },
      {
        name  = "controller.tolerations[0].operator"
        value = "Exists"
        type  = "string"
      },
      {
        name  = "controller.tolerations[0].effect"
        value = "NoSchedule"
        type  = "string"
    }]
  }

  cluster_autoscaler_helm_config = {
    version   = var.helm_chart_versions["cluster_autoscaler"]
    namespace = "kube-system"

    set = concat([{
      name  = "image.tag"
      value = "v${var.kubernetes_version}.1"
      },
      {
        name  = "replicaCount"
        value = 0
      }],
    local.system_component_values)
  }

  metrics_server_helm_config = {
    version = var.helm_chart_versions["metrics_server"]

    set = concat([], local.system_component_values)
  }

  aws_load_balancer_controller_helm_config = {
    version   = var.helm_chart_versions["aws-load-balancer-controller"]
    namespace = "aws-load-balancer-controller"

    set = concat([{
      name  = "replicaCount"
      value = 1
      },
      {
        name  = "vpcId"
        value = var.vpc_id
      }],
    local.system_component_values)
  }

  karpenter_helm_config = {
    version = "v${var.helm_chart_versions["karpenter"]}"
    timeout = 600

    set = concat([{
      name  = "replicas"
      value = "1"
      type  = "auto"
      },
      # {
      #   name  = "aws.defaultInstanceProfile"
      #   value = module.eks_blueprints.managed_node_group_iam_instance_profile_id[0]
      # },
      {
        name  = "controller.resources.requests.cpu"
        value = "300m"
        type  = "string"
      },
      {
        name  = "controller.resources.limits.cpu"
        value = "300m"
        type  = "string"
      }],
    local.system_component_values)
  }

  kubecost_helm_config = {
    set = concat([
      {
        name  = "blocker"
        value = local.ebs_csi_blocker
        type  = "string"
      },
      {
        name  = "prometheus.server.nodeSelector.workshop-system"
        value = "yes"
        type  = "string"
      },
      {
        name  = "prometheus.server.tolerations[0].key"
        value = "systemComponent"
        type  = "string"
      },
      {
        name  = "prometheus.server.tolerations[0].operator"
        value = "Exists"
        type  = "string"
      },
      {
        name  = "prometheus.server.tolerations[0].effect"
        value = "NoSchedule"
        type  = "string"
      },
      {
        name  = "prometheus.kube-state-metrics.nodeSelector.workshop-system"
        value = "yes"
        type  = "string"
      },
      {
        name  = "prometheus.kube-state-metrics.tolerations[0].key"
        value = "systemComponent"
        type  = "string"
      },
      {
        name  = "prometheus.kube-state-metrics.tolerations[0].operator"
        value = "Exists"
        type  = "string"
      },
      {
        name  = "prometheus.kube-state-metrics.tolerations[0].effect"
        value = "NoSchedule"
        type  = "string"
      },
      {
        name  = "prometheus.nodeExporter.tolerations[0].key"
        value = "systemComponent"
        type  = "string"
      },
      {
        name  = "prometheus.nodeExporter.tolerations[0].operator"
        value = "Exists"
        type  = "string"
      },
      {
        name  = "prometheus.nodeExporter.tolerations[0].effect"
        value = "NoSchedule"
        type  = "string"
      }],
    local.system_component_values)
  }

  aws_for_fluentbit_cw_log_group_name = "/${module.control-plane.eks_name}/worker-fluentbit-logs-${random_string.fluentbit_log_group.result}"

  amazon_eks_adot_config = {
    kubernetes_version = var.kubernetes_version
  }

  crossplane_helm_config = {
    set = concat([{
      name  = "rbacManager.nodeSelector.workshop-system"
      value = "yes"
      type  = "string"
      },
      {
        name  = "rbacManager.tolerations[0].key"
        value = "systemComponent"
        type  = "string"
      },
      {
        name  = "rbacManager.tolerations[0].operator"
        value = "Exists"
        type  = "string"
      },
      {
        name  = "rbacManager.tolerations[0].effect"
        value = "NoSchedule"
        type  = "string"
    }], local.system_component_values)
  }

  crossplane_aws_provider = {
    enable                   = true
    provider_aws_version     = "v0.36.0"
    additional_irsa_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  }

  argocd_helm_config = {
    name             = "argocd"
    chart            = "argo-cd"
    repository       = "https://argoproj.github.io/argo-helm"
    version          = "5.25.0"
    namespace        = "argocd"
    timeout          = 1200
    create_namespace = true

    set = concat([
      {
        name  = "server.service.type"
        value = "LoadBalancer"
      },
      {
        name  = "controller.replicas"
        value = "1"
      },
      {
        name  = "controller.nodeSelector.workshop-system"
        value = "yes"
        type  = "string"
      },
      {
        name  = "controller.tolerations[0].key"
        value = "systemComponent"
        type  = "string"
      },
      {
        name  = "controller.tolerations[0].operator"
        value = "Exists"
        type  = "string"
      },
      {
        name  = "controller.tolerations[0].effect"
        value = "NoSchedule"
        type  = "string"
      },
      {
        name  = "dex.nodeSelector.workshop-system"
        value = "yes"
        type  = "string"
      },
      {
        name  = "dex.tolerations[0].key"
        value = "systemComponent"
        type  = "string"
      },
      {
        name  = "dex.tolerations[0].operator"
        value = "Exists"
        type  = "string"
      },
      {
        name  = "dex.tolerations[0].effect"
        value = "NoSchedule"
        type  = "string"
      },
      {
        name  = "notifications.nodeSelector.workshop-system"
        value = "yes"
        type  = "string"
      },
      {
        name  = "notifications.tolerations[0].key"
        value = "systemComponent"
        type  = "string"
      },
      {
        name  = "notifications.tolerations[0].operator"
        value = "Exists"
        type  = "string"
      },
      {
        name  = "notifications.tolerations[0].effect"
        value = "NoSchedule"
        type  = "string"
      },
      {
        name  = "redis.nodeSelector.workshop-system"
        value = "yes"
        type  = "string"
      },
      {
        name  = "redis.tolerations[0].key"
        value = "systemComponent"
        type  = "string"
      },
      {
        name  = "redis.tolerations[0].operator"
        value = "Exists"
        type  = "string"
      },
      {
        name  = "redis.tolerations[0].effect"
        value = "NoSchedule"
        type  = "string"
      },
      {
        name  = "server.replicas"
        value = "1"
      },
      {
        name  = "server.autoscaling.enabled"
        value = "false"
      },
      {
        name  = "server.nodeSelector.workshop-system"
        value = "yes"
        type  = "string"
      },
      {
        name  = "server.tolerations[0].key"
        value = "systemComponent"
        type  = "string"
      },
      {
        name  = "server.tolerations[0].operator"
        value = "Exists"
        type  = "string"
      },
      {
        name  = "server.tolerations[0].effect"
        value = "NoSchedule"
        type  = "string"
      },
      {
        name  = "repoServer.replicas"
        value = "1"
      },
      {
        name  = "repoServer.autoscaling.enabled"
        value = "false"
      },
      {
        name  = "repoServer.nodeSelector.workshop-system"
        value = "yes"
        type  = "string"
      },
      {
        name  = "repoServer.tolerations[0].key"
        value = "systemComponent"
        type  = "string"
      },
      {
        name  = "repoServer.tolerations[0].operator"
        value = "Exists"
        type  = "string"
      },
      {
        name  = "repoServer.tolerations[0].effect"
        value = "NoSchedule"
        type  = "string"
      },
      {
        name  = "redis-ha.enabled"
        value = "false"
      },
      {
        name  = "applicationSet.replicaCount"
        value = "1"
      },
      {
        name  = "applicationSet.nodeSelector.workshop-system"
        value = "yes"
        type  = "string"
      },
      {
        name  = "applicationSet.tolerations[0].key"
        value = "systemComponent"
        type  = "string"
      },
      {
        name  = "applicationSet.tolerations[0].operator"
        value = "Exists"
        type  = "string"
      },
      {
        name  = "applicationSet.tolerations[0].effect"
        value = "NoSchedule"
        type  = "string"
      },
      {
        name  = "timeout.reconciliation"
        value = "60s"
    }], local.system_component_values)
  }

  tags = local.tags
}



locals {
  # oidc_url = replace(data.aws_eks_cluster.control-plane.identity[0].oidc[0].issuer, "https://", "")

  # addon_context = {
  #   aws_caller_identity_account_id = data.aws_caller_identity.current.account_id
  #   aws_caller_identity_arn        = data.aws_caller_identity.current.arn
  #   aws_eks_cluster_endpoint       = data.aws_eks_cluster.control-plane.endpoint
  #   aws_partition_id               = data.aws_partition.current.partition
  #   aws_region_name                = data.aws_region.current.id
  #   eks_cluster_id                 = module.control-plane.eks_name
  #   eks_oidc_issuer_url            = local.oidc_url
  #   eks_oidc_provider_arn          = "arn:${data.aws_partition.current.partition}:iam::${local.aws_account_id}:oidc-provider/${local.oidc_url}"
  #   irsa_iam_role_path             = "/"
  #   irsa_iam_permissions_boundary  = ""
  #   tags                           = {}
  # }

  system_component_values = [{
    name  = "nodeSelector.workshop-system"
    value = "yes"
    type  = "string"
    },
    {
      name  = "tolerations[0].key"
      value = "systemComponent"
      type  = "string"
    },
    {
      name  = "tolerations[0].operator"
      value = "Exists"
      type  = "string"
    },
    {
      name  = "tolerations[0].effect"
      value = "NoSchedule"
      type  = "string"
  }]
}
