variable "secman_secret_entries" {
  type = list(object({
    key   = string
    value = string
  }))
  description = "AWS Secrets Manager keys"
}

variable "secret_manager_name" {
  type        = string
  description = "AWS Secret Managery entry name"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}
