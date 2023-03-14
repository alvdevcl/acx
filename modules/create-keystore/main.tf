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

resource "random_password" "keystore" {
  length  = 16
  special = false
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "null_resource" "create_keystore" {
  triggers = {
    keystore = local.keystore_path
  }

  provisioner "local-exec" {
    command = "${local.scripts_path}/create-keystore.sh ${local.keystore_password}"

    environment = {
      KEYSTORE   = local.keystore_path
      KEY_ALG    = var.key_alg
      KEY_ALIAS  = var.key_alias
      KEY_SIZE   = var.key_size
      STORE_TYPE = var.store_type
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm ${self.triggers.keystore}"
  }
}

data "local_file" "keystore" {
  filename = local.keystore_path
  depends_on = [
    null_resource.create_keystore
  ]
}

locals {
  scripts_path      = "${abspath(path.module)}/scripts"
  keystore_path     = "/tmp/keystore-${random_string.suffix.id}.jks"
  keystore_base64   = data.local_file.keystore.content_base64
  keystore_password = random_password.keystore.result
}
