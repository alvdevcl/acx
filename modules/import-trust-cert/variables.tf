variable "service_name" {
  type        = string
  description = "Ops360 service name"
}

variable "keystore" {
  type        = string
  description = "Base64 encoded keystore"
}

variable "store_pass" {
  type        = string
  description = "Java keystore password"
  sensitive   = true
}

variable "trust_cert" {
  type        = string
  description = "Base64 encoded trust cert"
}

variable "trust_cert_key_alias" {
  type        = string
  description = "Alias to shared key trust"
  default     = "ac-authentication"
}
