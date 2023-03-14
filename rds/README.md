
<div><h2><img src="../alveo-small.png" width="100" height="100">Ops360 Terraform - Amazon RDS Postgres</h2></div>

> Amazon RDS deployment using Capital Group provided modules

## Deployment

Ops360 requires a postgres database. A reachable postgres database needs to be available to achieve a successful ops360 deployment.

```shell
## Change into the rds directory
cd rds/

## Copy the terraform.tfvars-template file to terraform.tfvars
## Linux
cp terraform.tfvars-template terraform.tfvars

## Windows
copy terraform.tfvars-template terraform.tfvars

## Installs any terraform providers/modules required
terraform init

## Deploy
terraform apply
```

The terraform.tfvars-template file contains values used by a specific test vpc. Each VPC may have different values that need to be updated. Please refer to the terraform.tfvars-template file.

## Production: Deployment

Please review the settings found within the terraform.tfvars-template file. Several options may need to be updated to meet production standards within the Capital Group environment

## Retrieving connection details and credentials

Once the deployment has completed. The Capital Group module sets relevant connection details and credentials within an AWS secret.

Get the secret values and set them into the pg_service.conf file located within the rds/scripts directory.

```shell
## Retrieve the secret string
aws secretsmanager get-secret-value --secret-id ap_master_aa00002195_dev_ops360rds --query SecretString --output text

## Copy the pg_service.conf-template to pg_service.conf
## Linux
cp pg_service.conf-template pg_service.conf

## Windows
copy pg_service.conf-template pg_service.conf

## Edit the pg_service.conf file and set the missing parameters
```

## Create Database Schemas and Users

Ops360 services use a postgres database as the main persistence layer. Each service should have a unique set of credentials and database schema permissioned accordingly. A convenience script included creates the necessary schemas and users with the following values:

| Service | Database Name | User | Password |
|:------ | :----------- |:--- | :------ |
| Authentication | authdb | authuser | authpass |
| Business Domain Model | bdmsdb | bdmsuser | bdmspass |
| Datasets | datasetsdb | datasetsuser | datasetspass |
| Spreadsheets Processing | spsdb | spsuser | spspass |

Executing the following scripts will prepare the database using the information above.

```shell
## Windows
C:\<PROJECT_ROOT>\rds\scripts\db_setup.bat

## Linux
<PROJECT_ROOT>/rds/scripts/db_setup.sh
```

### Production: Users and Schemas

In a production environment admin access required to create users and schemas may rest with another team. It is strongly recommended assigning each service unique user accounts.
