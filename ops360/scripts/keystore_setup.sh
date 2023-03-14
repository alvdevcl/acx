#!/bin/bash
KEYSTORE_KEY_ALIAS=ac-authentication
KEYSTORE_KEY_PASSWORD=j%0CVDl#40t26u9H
KEYSTORE_PASSWORD=j%0CVDl#40t26u9H
KEYSTORE_SIG_ALG=SHA256withRSA

## Clear path
rm keystore.jks
rm keystore.jks.b64

keytool -genkey -alias $KEYSTORE_KEY_ALIAS -keyalg RSA -keysize 2048 -keystore keystore.jks -storetype pkcs12 -sigalg $KEYSTORE_SIG_ALG -dname "cn=Ops360 Microservices, ou=DevOps, o=Alveo, c=US" -storepass $KEYSTORE_PASSWORD

base64 -w 0 keystore.jks > keystore.jks.b64

cat keystore.jks.b64