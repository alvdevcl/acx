variable "eks_cluster_name" {
  type    = string
  default = "Ops360 EKS Cluster"
}

variable "subnet_ids" {
  type = list(string)
  default = [
    "subnet-078682fb0951936d1",
    "subnet-0d3e07935980edf54",
    "subnet-086c7824dd82f893e",
    "subnet-0a0363adfd4368103"
  ]
}

variable "environment_suffix" {
  type        = string
  description = "Suffix for the workshop environment name"
  default     = ""
}

variable "kms_key_arn" {
  type    = string
  default = "arn:aws:kms:us-east-1:573361717332:key/8c6a281d-b4f5-4df0-b6c9-ebeb88412b43"
}

variable "permissions_boundary" {
  type    = string
  default = "arn:aws:iam::573361717332:policy/AdminPermissionsBoundary20230310085833882800000001"
}

variable "eks_role_arns" {
  type        = list(string)
  default     = []
  description = "Additional IAM roles that should be added to the AWS auth config map"
}

variable "kubernetes_version" {
  type    = string
  default = "1.23"
}


variable "tags" {
  type        = map(string)
  description = "AWS tags that will be applied to all resources"
  default     = {}
}

variable "vpc_cni_addon_version" {
  type    = string
  default = "v1.12.1-eksbuild.1"
}

variable "vpc_cni_resolve_conflicts" {
  type    = string
  default = "OVERWRITE"
}

variable "vpc_id" {
  type = string
}

variable "node_group_name" {
  type    = string
  default = "Ops360 Node Group 1"
}

variable "desired_size" {
  type    = number
  default = 4
}

variable "max_size" {
  type    = number
  default = 4
}

variable "min_size" {
  type    = number
  default = 4
}

variable "base_domain" {
  type    = string
  default = "rdm.aws-dev.capgroup.com"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "secondary_aws_region" {
  type    = string
  default = "us-east-2"
}

variable "cost_center" {
  type = string
}

variable "exp_date" {
  type = string
}

variable "env" {
  type = string
}

variable "aws_load_balancer_controller_enable" {
  type = bool
  default = true
}

variable "atm_id" {
  type = string
}

variable "ppmc_id" {
  type = string
}

variable "sd_period" {
  type = string
}

variable "toc" {
  type = string
}

variable "node_instance_type" {
  type        = string
  description = "EKS node group instance type"
  default     = "t3.xlarge"
}


variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth ConfigMap"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}


variable "environment_name" {
  type        = string
  description = "Workshop environment name"
  default = "dev"
}

variable "cluster_version" {
  type        = string
  description = "EKS cluster version"
  default     = "1.23"
}