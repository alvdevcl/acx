<div><h2><img src="../alveo-small.png" width="100" height="100">Ops360 Terraform Deployment</h2></div>

> Ops360 Terraform deployment modules

## Deployment

Ops360 microservices will be installed using a Terraform to setup infrastructure elements and helm charts to create kubernetes objects and deploy.

Microservices have independent terraform modules located within the ops360/services directory. Each module executes a corresponding helm chart located within the ops360/helm directory.

```shell
## From the project root, change into the ops360/ directory
cd ops360/

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

### Deployment Test

After the terraform scripts have completed, all pods should be in the ready state. This can be verified by executing the following commands:

```

## Okta authentication must be performed.

# Lists all pods within the ops360 namespace

Kubectl get pods -n ops360

```

## Production: Deployment

Please review the settings found within the terraform.tfvars-template file. Several options may need to be updated to meet production standards within the Capital Group environment

## Variable Breakdown

The Ops360 product is broken down into several microservices. Each microservice exposes a litany of configuration variables.

To aid readability, the expected variables.tf file has been split into several files each named after the set of variables included.

### Kubectl Context Setup

```shell
## Optional: Set the ops360 namespace as the default namespace context
kubectl config set-context --current --namespace=ops360
```
