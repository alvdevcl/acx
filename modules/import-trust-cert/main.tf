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

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "local_file" "keystore" {
  filename       = local.keystore_path
  content_base64 = var.keystore
}

resource "local_file" "trust_cert" {
  filename       = local.trust_cert_path
  content_base64 = var.trust_cert
}

resource "null_resource" "import_trust_cert" {
  provisioner "local-exec" {
    command = "${local.scripts_path}/import-cert.sh ${var.store_pass}"

    environment = {
      KEYSTORE             = local.keystore_path
      TRUST_CERT_KEY_ALIAS = var.trust_cert_key_alias
      TRUST_CERT           = local.trust_cert_path
    }
  }

  depends_on = [
    local_file.keystore,
    local_file.trust_cert
  ]
}

data "local_file" "keystore" {
  filename = local.keystore_path
  depends_on = [
    null_resource.import_trust_cert
  ]
}

locals {
  scripts_path    = "${abspath(path.module)}/scripts"
  keystore_path   = "/tmp/keystore-${random_string.suffix.id}.jks"
  keystore_base64 = data.local_file.keystore.content_base64
  trust_cert_path = "/tmp/trust-cert-${random_string.suffix.id}.crt"
}
