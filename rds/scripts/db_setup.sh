#!/bin/bash

# The following credentials must be able to create a schema and user
# We will be using the default credentials created by the rds terraform scripts
export PGSERVICE=ops360db
export PGSERVICEFILE=pg_service.conf

export PGSSLMODE=prefer
export PGSSLCOMPRESSION=False
export PGSSLROOTCERT=rds-ca-2019-root.pem

# The following variable lists the services requiring postgres setup
SERVICES=("authdb authuser authpass" "bdmsdb bdmsuser bdmspass" "datasetsdb datasetsuser datasetspass" "spsdb spsuser spspass")

for s in "${SERVICES[@]}"; do
	IFS=' ' read dbname dbuser dbpass <<< $s
	DATABASE=$dbname
	USERNAME=$dbuser
	PASSWORD=$dbpass

	psql << EOF
CREATE USER $USERNAME WITH ENCRYPTED PASSWORD '$PASSWORD';
CREATE DATABASE $DATABASE;
GRANT ALL PRIVILEGES ON DATABASE $DATABASE TO $USERNAME;
EOF
done