#!/bin/bash

COMMAND=${1:-missing}

shift 1;
ARGS=$@

# Setup Postgres DB
# Inputs
#   database_name
#   role_password
# Required ENV Variables
#   PGHOST=
#   PGPORT=
#   PGUSER=
#   PGPASSWORD=
#   PGDATABASE=
#   PGSSLMODE=prefer
#   PGSSLCOMPRESSION=False
#   PGSSLROOTCERT=./rds-ca-2019-root.pem
#   PG_CRED_FILE_NAME=
apply_postgres () {
  local database=$1
  local username=$2
  local password=$3

psql << EOF
DROP DATABASE IF EXISTS $database;
DROP ROLE IF EXISTS $username;

CREATE ROLE $username WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1
	PASSWORD '$password';

CREATE DATABASE $database
	WITH
	OWNER = $PGUSER
	ENCODING = 'UTF8'
	CONNECTION LIMIT = -1;

GRANT ALL ON DATABASE $database TO $username;
EOF
}

# Destroy Postgres DB Setup
# Inputs
#   database_name
# Required ENV Variables
#   PGHOST=
#   PGPORT=
#   PGUSER=
#   PGPASSWORD=
#   PGDATABASE=
#   PGSSLMODE=prefer
#   PGSSLCOMPRESSION=False
#   PGSSLROOTCERT=./rds-ca-2019-root.pem
destroy_postgres () {
  local database=$1
  local username="${database}_user"

psql << EOF
DROP DATABASE IF EXISTS $database;
DROP ROLE IF EXISTS $username;
EOF
}

case "$COMMAND" in
  apply)
    apply_postgres $ARGS
    ;;
  destroy)
    destroy_postgres $ARGS
    ;;
  *)
    echo "Valid Commands"
    echo "apply"
    echo "destroy"
    exit 1
    ;;
esac