terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.0"
    }
  }
}

resource "local_file" "keystore" {
  filename       = local.keystore_path
  content_base64 = var.keystore
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "null_resource" "export_trust_cert" {
  triggers = {
    trust_cert = local.trust_cert_path
  }

  provisioner "local-exec" {
    command = "${local.scripts_path}/export-cert.sh ${var.store_pass}"

    environment = {
      KEYSTORE   = local.keystore_path
      KEY_ALIAS  = var.alias
      TRUST_CERT = local.trust_cert_path
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm ${self.triggers.trust_cert}"
  }

  depends_on = [
    local_file.keystore
  ]
}

data "local_file" "trust_cert" {
  filename = local.trust_cert_path
  depends_on = [
    null_resource.export_trust_cert
  ]
}

locals {
  scripts_path      = "${abspath(path.module)}/scripts"
  keystore_path     = "/tmp/keystore-${random_string.suffix.id}.jks"
  trust_cert_path   = "/tmp/trust-cert-${random_string.suffix.id}.crt"
  trust_cert_base64 = data.local_file.trust_cert.content_base64
}
