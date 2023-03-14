# Ops360 - Data Sets Service Terraform Scripts
> Terraform scripts designed for a Capital Group development environment.

### Prerequisites
This service uses a postgres database for persistent storage and a Java keystore loaded with cryptographic keys.

- Postgres AWS secret document arn
- Java Keystore AWS secret document arn

The Postgres secret document should be created by running the rds module folder. The Java keystore is created by the create-keystore module executed by the main.tf in the dev folder.

### Usage
This module is intended to be used as a sub-module to the parent script. As such, it is missing the provider configurations required.

## What it does
The module sets up auth-service and required dependencies in a development environment.

- Creates a service specific AWS Secret document.
- Creates a postgres user and database with ALL privileges granted
- Configures the external secret plugin
- Deploys the service using Helm

### TODO and Known Issues
- Grant the database user minimal privileges needed