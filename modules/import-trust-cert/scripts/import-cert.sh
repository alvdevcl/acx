#!/bin/bash

# Import public trust cert
#
# Inputs
#   password
# Required ENV Variables
#   KEYSTORE=keystore.jks
#   TRUST_CERT_KEY_ALIAS=ac-authentication
#   TRUST_CERT=trust_cert.crt

STORE_PASS=${1:-changeme}

keytool -importcert -trustcacerts \
  -no-prompt \
  -rfc \
  -alias ${TRUST_CERT_KEY_ALIAS:-ac-authentication} \
  -file ${TRUST_CERT:-trust_cert.crt} \
  -keystore ${KEYSTORE:-keystore.jks} \
  -storepass $STORE_PASS