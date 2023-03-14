#!/bin/bash

# Export trust cert from ca keystore
#
# Inputs
#   password
# Required ENV Variables
#   KEY_ALIAS=autogen
#   KEYSTORE=keystore.jks
#   TRUST_CERT=trust_cert.crt

STORE_PASS=${1:-changeme}

keytool -export \
  -alias ${KEY_ALIAS:-autogen} \
  -file ${TRUST_CERT:-trust_cert.crt} \
  -keystore ${KEYSTORE:-keystore.jks} \
  -storepass $STORE_PASS