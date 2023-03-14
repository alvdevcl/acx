variable "eks_cluster_name" {
  type    = string
  default = "Ops360 EKS Cluster"
}

variable "subnet_ids" {
  type = list(string)
  default = [
    "subnet-040ea8d97a5a09ea1",
    "subnet-04cb026a4a2ed5204",
    "subnet-099a9520b2b184218",
    "subnet-0d82867bd6b22740f"
  ]
}

variable "kms_key_arn" {
  type    = string
  default = "arn:aws:kms:us-east-1:039556708828:key/41f38145-508e-421b-b471-32cfcc6585df"
}

variable "permissions_boundary" {
  type    = string
  default = "arn:aws:iam::573361717332:policy/AdminPermissionsBoundary20230310085833882800000001"
}

variable "kubernetes_version" {
  type    = string
  default = "1.23"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_cni_addon_version" {
  type    = string
  default = "v1.11.4-eksbuild.1"
}

variable "vpc_cni_resolve_conflicts" {
  type    = string
  default = null
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

variable "primary_secman_vpc_end_point" {
  type = string
}
