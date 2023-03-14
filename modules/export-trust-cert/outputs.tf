output "trust_cert" {
  value       = local.trust_cert_base64
  description = "Public key trustcert exported from ca jks"
}

