output "keystore" {
  value       = local.keystore_base64
  description = "Java keystore base64 encoded"
}

output "store_pass" {
  value       = local.keystore_password
  description = "Java keystore password"
}

output "key_alias" {
  value       = var.key_alias
  description = "Java keystore key alias"
}

output "signature_algorithm" {
  value       = var.sig_alg
  description = "Java keystore signature algorithm"
}
