#!/bin/bash

export SERVICES="auth-service" "bdms-service" "data-sets-service" "spreadsheet-processing-service"

for s in "${SERVICES[@]}"; do
  aws secretsmanager create-secret --name dev/ops360/$s --description "$s Secrets." --secret-string file://services/$s/secrets-template.json
done