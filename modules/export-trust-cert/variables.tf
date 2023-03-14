variable "service_name" {
  type        = string
  description = "Ops360 service name"
}

variable "keystore" {
  type        = string
  description = "Base64 encoded keystore"
}

variable "alias" {
  type        = string
  description = "Java keystore key alias entry to export"
}

variable "store_pass" {
  type        = string
  description = "Java keystore password"
  sensitive   = true
}
