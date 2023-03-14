@ECHO OFF

:: This batch contains ops360 database setup configuration

TITLE Postgres Database Setup

:: If the psql.exe command is not in the %PATH%, set it here
@REM set PSQL_PATH=C:\"Program Files"\"pgAdmin 4"\v6\runtime\

:: The following credentials must be able to create a schema and user
:: We will be using the default credentials created by the rds terraform scripts
set PGSERVICE=ops360db
set PGSERVICEFILE=pg_service.conf
set PGSSLMODE=prefer
set PGSSLCOMPRESSION=False
set PGSSLROOTCERT=rds-ca-2019-root.pem

:: The following variable lists the services requiring postgres setup
set OPS360_SERVICES="authdb authuser authpass" "bdmsdb bdmsuser bdmspass" "datasetsdb datasetsuser datasetspass" "spsdb spsuser spspass"

(for %%S in (%OPS360_SERVICES%) do (
  for /f "tokens=1,2,3" %%G IN (%%S) do (
    ECHO "Seting up %%G"
    %PSQL_PATH%psql.exe -c "CREATE USER %%H WITH ENCRYPTED PASSWORD '%%I';"^
    -c "CREATE DATABASE %%G;"^
    -c "GRANT ALL PRIVILEGES ON DATABASE %%G TO %%H;"
  )
))