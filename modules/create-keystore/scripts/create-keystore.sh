#!/bin/bash

# Generate keystore and import public trust cert
# Inputs
#   password
# Required ENV variables and default value
#   KEYSTORE=keystore.jks
#   KEY_ALG=RSA
#   KEY_ALIAS=autogen
#   KEY_SIZE=2048
#   STORE_TYPE=PKCS12

STORE_PASS=${1:-changeme}

keytool -genkey \
  -alias ${KEY_ALIAS:-autogen} \
  -keyalg ${KEY_ALG:-RSA} \
  -validity 365 \
  -keysize ${KEY_SIZE:-2048} \
  -storepass $STORE_PASS \
  -storetype ${STORE_TYPE:-PKCS12} \
  -keystore  ${KEYSTORE:-keystore.jks} \
  -dname "CN=Ops360 Services, OU=DevOps, O=Alveo, L=London, C=UK"