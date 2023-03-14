# Ops360 - Authentication Service Module
> Terraform scripts designed for a Capital Group development environment.

### Prerequisites
This service uses a postgres database for persistent storage and a Java keystore loaded with cryptographic keys.

- Postgres AWS secret document arn
- Java Keystore AWS secret document arn

### Usage
This module is intended to be used as a sub-module to the parent script.

### Auth Service Secret Table
| Key | Description | Default |
|:----- | :------ | :----- |
| POSTGRES_USERNAME | Postgres username | authdbuser |
| POSTGRES_PASSWORD | Postgres password | |
| POSTGRES_DATABASE | Postgres database name | authdb |
| POSTGRES_HOST | Postgres Host | |
| POSTGRES_PORT | Postgres Host Port | |
| PLAY_HTTP_SECRET_KEY | Playframework Secret Key | |
| KEYSTORE_KEY_ALIAS | Java Keystore Key Alias | ac-authentication |
| KEYSTORE_KEY_PASSWORD | Java Keystore Key Password | |
| KEYSTORE_PASSWORD | Java Keystore Password | |
| KEYSTORE_SIG_ALG | Keystore Signature Algorithm | SHA256withRSA |
| KEYSTORE_FILE | Base64 Encoded Java Keystore | |

## What it does
The module sets up auth-service and required dependencies in a development environment.

- Creates a service specific AWS Secret document.
- Configures the external secret plugin
- Deploys the service using Helm
