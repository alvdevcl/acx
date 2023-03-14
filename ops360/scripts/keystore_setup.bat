@ECHO OFF

:: This batch contains Java Keystore Setup

TITLE Java Keystore Setup

set KEYSTORE_KEY_ALIAS=
set KEYSTORE_KEY_PASSWORD=
set KEYSTORE_PASSWORD=
set KEYSTORE_SIG_ALG=

keytool -genkey -alias %KEYSTORE_KEY_ALIAS% -keyalg RSA -keysize 2048 -keystore keystore.jks -storetype pkcs12 -sigalg %KEYSTORE_SIG_ALG% -dname "cn=Ops360 Microservices, ou=DevOps, o=Alveo, c=US" -storepass %KEYSTORE_PASSWORD%

certutil -encodehex -f keystore.jks keystore.jks.b64 0x40000001