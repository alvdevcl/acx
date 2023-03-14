variable "service_name" {
  type        = string
  description = "Ops360 service name"
  default     = "auth-service"
}

variable "key_alias" {
  type        = string
  description = "Alias name of the entry to process"
  default     = "autogen"
}

variable "key_alg" {
  type        = string
  description = "Key algorithm name"
  default     = "RSA"
}

variable "key_size" {
  type        = number
  description = "Key bit size"
  default     = 2048
}

variable "sig_alg" {
  type        = string
  description = "Signature algorithm name"
  default     = "SHA256withRSA"
}

variable "store_type" {
  type        = string
  description = "Type of keystore to be instantiated"
  default     = "PKCS12"
}
