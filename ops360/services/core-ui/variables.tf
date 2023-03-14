variable "service_name" {
  type        = string
  description = "Microservice name"
  default     = "core-ui"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "dev"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "route53_base_domain" {
  type        = string
  description = "Hostname used by the alb ingress"
  default     = "ops360.rdm.aws-dev.capgroup.com"
}

variable "eks_cluster_name" {
  type        = string
  description = "EKS Cluster Name"
  default     = "Ops360EKSCluster"
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace"
  default     = "ops360"
}

variable "k8s_cpu_limit" {
  type        = string
  description = "Pod CPU resource limit"
  default     = "1"
}

variable "k8s_memory_limit" {
  type        = string
  description = "Pod memory resource limit"
  default     = "2G"
}

variable "k8s_cpu_request" {
  type        = string
  description = "Pod CPU resource request"
  default     = "1"
}

variable "k8s_memory_request" {
  type        = string
  description = "Pod memory resource request"
  default     = "2G"
}

variable "image" {
  type        = string
  description = "Service image url"
}
