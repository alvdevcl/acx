@ECHO OFF

:: This batch contains ops360 secrets setup configuration

TITLE AWS Secrets Setup

set OPS360_SERVICES="auth-service" "bdms-service" "data-sets-service" "spreadsheet-processing-service"

(for %%S in (%OPS360_SERVICES%) do (
    aws secretsmanager create-secret --name dev/ops360/%%S --description "%%S Secrets." --secret-string file://services/%%S/secrets-template.json
))