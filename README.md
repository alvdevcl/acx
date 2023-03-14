<!-- ![alt text](https://www.alveotech.com/wp-content/themes/alveo/assets/images/overlay-circle.png "Alveo Logo") -->

<div><h2><img src="./alveo-small.png" width="100" height="100">Ops360 Terraform</h2></div>

- [Project Breakdown](#project-breakdown)
- [Prerequisites](#prerequisites)
  - [Terraform](#terraform)
  - [Helm](#helm)
  - [Kubectl](#kubectl)
  - [Python3](#python3)
  - [pgAdmin](#pgadmin)
  - [AWS Okta CLI Tool](#aws-okta-cli-tool)
    - [Adding Terraform, Helm and Kubectl binaries to the PATH](#adding-terraform-helm-and-kubectl-binaries-to-the-path)
- [Retrieving the Source Code](#retrieving-the-source-code)
  - [Cloning the repository](#cloning-the-repository)
- [Sensitive Information - AWS Secrets Manager](#sensitive-information---aws-secrets-manager)
  - [Postgres Setup](#postgres-setup)
    - [Production: Update Postgres settings and credentials](#production-update-postgres-settings-and-credentials)
  - [EKS Setup](#eks-setup)
    - [Production: Notes](#production-notes)
  - [Java Keystore Setup](#java-keystore-setup)
    - [Production: Generate a new java keystore](#production-generate-a-new-java-keystore)
  - [Play Framework Application Secret](#play-framework-application-secret)
    - [Production: Generate Application Secrets](#production-generate-application-secrets)
  - [Prime and Oracle Credentials](#prime-and-oracle-credentials)
    - [Production: Updating Prime Connection Settings and Credentials](#production-updating-prime-connection-settings-and-credentials)
    - [Production: Updating Oracle Connection Settings and Credentials](#production-updating-oracle-connection-settings-and-credentials)
- [Ops360 Deployment](#ops360-deployment)

## Project Breakdown

- ./eks
  > AWS Elastic Kubernetes Service setup using Capital Group modules.
- ./helm
  > All Ops360 service helm charts are here. They are (mostly) written kubernetes flavor agnostic.
- ./modules
  > Reusable Terraform modules
- ./ops360
  > Production ready Terraform scripts.
- ./rds
  > AWS Relational Database Service setup using Capital Group modules.

## Prerequisites

The project deploys into the AWS ecosystem. This requires aws related tools aside from Terraform and Helm.

### Terraform

Download the binary from the [Terraform installation page](https://developer.hashicorp.com/terraform/downloads?ajs_aid=32dfc08e-caac-4165-b60d-46f4a87811cc&product_intent=terraform)

### Helm

Download the latest windows binary from the [Helm github releases page](https://github.com/helm/helm/releases)
_For other installation options, see the [Helm install guide](https://helm.sh/docs/intro/install/)_

### Kubectl

Download the latest stable binary from the [Kubernetes Tools page](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/)
_For other installation options, see the [Kubernetes Install Tools Section](https://kubernetes.io/docs/tasks/tools/#kubectl)_

### Python3

Python3 is available from the _[cgappstore software page](http://cgappstore)_, search for _'Python'_. Select version 3+ - User tile.

### pgAdmin

pgAdmin is available from the _[cgappstore software page](http://cgappstore)_, search for _'pgAdmin'_.

### AWS Okta CLI Tool

Capital group uses a third-party authentication/authorization tool from Okta. Python3 is required to run and install the okta cli tool.

```shell
## Create a new virtualEnv
python -m venv .\venv

## Execute the following command to activate the venv created
venv\Scripts\activate.bat

## Run these commands within the venv created.
pip3 install -i https://cgrepo.capgroup.com/repository/cgpypi/pypi/ --extra-index-url https://cgrepo.capgroup.com/repository/cgpypi/simple/ --trusted-host cgrepo.capgroup.com python-certifi-win32
pip3 install -i https://cgrepo.capgroup.com/repository/cgpypi/pypi/ --extra-index-url https://cgrepo.capgroup.com/repository/cgpypi/simple/ --trusted-host cgrepo.capgroup.com okta-awscli

## Force reinstall ensures it gets path settings correctly in the venv, in case its already installed outside of the venv
pip3 install -i https://cgrepo.capgroup.com/repository/cgpypi/pypi/ --extra-index-url https://cgrepo.capgroup.com/repository/cgpypi/simple/ --trusted-host cgrepo.capgroup.com --force-reinstall awscli
```

Using your favorite text editor, create the okta configuration file using the template below. There are two variables that need to be updated.

| Variable   | Default Value   | Where to get it |
|:---|:---|:---|
| aws_account_id  |   | The account id is listed in the aws web ui under your login name at the top right |
| role_name | Broad-access-role | Found in the account selection menu when logging in to the aws web console |

```shell
## Windows - C:\Users\<Your CG ID>\.okta-aws
## Linux - ~/.okta-aws

[default]
base-url = capgroup.okta.com

[ndev]
base-url = capgroup.okta.com
app-link = https://capgroup.okta.com/home/amazon_aws/0oa1de6tkhz8ZdOkp1d8/272
role = arn:aws:iam::<aws_account_id>:role/<role_name>
duration = 28800
```

Execute the following command using your Capital Group credentials

```shell
okta-awscli --okta-profile ndev --profile ndev-creds
```

_Full instructions can be found within the [Capital Group Confluence page](https://confluence.capgroup.com/pages/viewpage.action?spaceKey=IAM&title=okta-awscli)_

#### Adding Terraform, Helm and Kubectl binaries to the PATH

Place the Terraform, Helm and Kubectl binaries in a path of your choice.

1. Open System Properties
2. Click on the Advanced tab
3. Select the "Environment Variables" button
4. Find the "PATH" variable in the "User Variables" pane
5. Select "Path" and click "Edit"
6. There enter the path to the binaries



## Retrieving the Source Code

Once all the tools have been installed, we are ready to clone the environment.

### Cloning the repository

Replace the _url_ variable below with the correct remote repository.

```shell
git clone <url>

## Change into the PROJECT_ROOT
cd capital-group-terraform
```

## Sensitive Information - AWS Secrets Manager

Credentials and other sensitive information are kept within the AWS Secrets Manager. A convenience script is included that creates all the required secrets.
Included in each service is a secrets-template.json file containing the required keys with default values useful for a development environment.

Executing the following command creates the secret entries in AWS:

```shell
cd <PROJECT_ROOT>/ops360

## Windows
scripts\secrets_setup.bat

## Linux
scripts/secrets_setup.sh
```

### Postgres Setup

Ops360 services that use postgres require unique credentials and schemas. Before proceeding to deploy ops360, please complete the setup instruction found within the [RDS README.md](rds/README.md).

#### Production: Update Postgres settings and credentials

After completing the commands found in the _Sensitive Information - AWS Secrets Manager_ section, services requiring postgres database access are preloaded with defaults appropriate for a development environment. For production, each service must have its respective aws secret updated with the following values:

- POSTGRES_USERNAME
- POSTGRES_PASSWORD
- POSTGRES_DATABASE
- POSTGRES_HOST
- POSTGRES_PORT

### EKS Setup

Ops360 software runs as a set of microservices that are orchestrated using Kubernetes. In our case, we will be deploying into the AWS flavor of kubernetes called EKS. Before proceeding to deploy ops360, please complete the setup instruction found within the [EKS README.md](eks/README.md).

#### Production: Notes

Please review the settings found within the terraform.tfvars-template file. Several options may need to be updated to meet production standards within the Capital Group environment

### Java Keystore Setup

Ops360 services authentication and authorize users based on a JWT token. The digital signature used to verify the token's authenticity is stored within a java keystore.

A default java keystore is already present during the initial secrets setup found in the _Sensitive Information - AWS Secrets Manager_ section. Creating a new keystore is not required for a development environment

#### Production: Generate a new java keystore

Changing the keystore password or generating a new keystore can be done using the scripts/keystore_setup file. The keystore_setup file contains the following variables:

- KEYSTORE_KEY_PASSWORD
- KEYSTORE_PASSWORD

Before execution, alter the above variables to something suitable for production. Executing scripts will generate the keystore and display it's base64 representation. The resulting string must be added to all service's aws secret under the key "KEYSTORE_FILE"

```shell
cd <PROJECT_ROOT>/ops360

## Windows
scripts\keystore_setup.bat

## Linux
scripts/keystore_setup.sh
```

### Play Framework Application Secret</a>

Ops360 services are built using the [Play Framework](https://www.playframework.com). Play uses a secret key generated using a base64 encoded 32-byte random number.

Unique keys are already present during the initial setup found in the _Sensitive Information - AWS Secrets Manager_ section. Creating new keys is not required for a development environment

#### Production: Generate Application Secrets

Executing the following commands will generate a key. Each service must have a unique application key added to the corresponding aws secret under the key "PLAY_HTTP_SECRET_KEY"

```bash
## Linux
head -c 32 /dev/urandom | base64

## Windows 10/2016+ Powershell
[Convert]::ToBase64String((1..32|%{[byte](Get-Random -Max 256)}))

```

### Prime and Oracle Credentials

By default, services are configured to use the ite4 environment. Default values do not include password details. PRIME_PASSWORD and ORACLE_PASSWORD must be updated from the default value.

#### Production: Updating Prime Connection Settings and Credentials

The Business Domain Model Service connects to Prime using the ac-api library. Connection settings and credentials are stored within the corresponding aws secret under the following keys:

- PRIME_USERNAME
- PRIME_PASSWORD
- PRIME_INSTALLATION
- PRIME_HOST

#### Production: Updating Oracle Connection Settings and Credentials

The Business Domain Model Service connects to the same Oracle database as Prime. Connection settings and credentials are stored within the corresponding aws secret under the following keys:

- ORACLE_USERNAME
- ORACLE_PASSWORD
- ORACLE_DATABASE
- ORACLE_HOST
- ORACLE_PORT

## Ops360 Deployment

After RDS and EKS are setup. We can now proceed to the Ops360 deployment. The terraform scripts are found within the ops360 directory.

Full deployment instructions are found within the [Ops360 README.md](ops360/README.md)
