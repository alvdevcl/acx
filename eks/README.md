<div><h2><img src="../alveo-small.png" width="100" height="100">Ops360 Terraform - Amazon Elastic Kubernetes Service</h2></div>

> Amazon EKS deployment using Capital Group provided modules

## Deployment

Ops360 software runs as a set of microservices that are orchestrated using Kubernetes. In our case, we will be deploying into the AWS flavor of kubernetes called EKS.

```shell
## From the project root, change into the eks/ directory
cd eks/

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

## Known Issues

Deployment may fail with the error below. This is expected due to timing issues in the capital group module. Please re-run the apply process.

```shell
module.eks-infra-common-components.helm_release.external_secrets_operator[0]: Creation complete after 2m30s [id=external-secrets]
╷
│ Error: unexpected EKS Add-On (Ops360EKSCluster:coredns) state returned during creation: unexpected state 'CREATE_FAILED', wanted target 'ACTIVE'. last error: 1 error occurred:
│       * : ConfigurationConflict: Conflicts found when trying to apply. Will not continue due to resolve conflicts mode. Conflicts:
│ Deployment.apps coredns - .spec.template.spec.containers[name="coredns"].image
│
│
│ [WARNING] Running terraform apply again will remove the kubernetes add-on and attempt to create it again effectively purging previous add-on configuration
│
│   with module.eks-infra-common-components.aws_eks_addon.core_dns,
│   on .terraform\modules\eks-infra-common-components\main.tf line 251, in resource "aws_eks_addon" "core_dns":
│  251: resource "aws_eks_addon" "core_dns" {
│
╵
│ Error: unexpected EKS Add-On (Ops360EKSCluster:kube-proxy) state returned during creation: unexpected state 'CREATE_FAILED', wanted target 'ACTIVE'. last error: 1 error occurred:
│       * : ConfigurationConflict: Conflicts found when trying to apply. Will not continue due to resolve conflicts mode. Conflicts:
│ DaemonSet.apps kube-proxy - .spec.template.spec.containers[name="kube-proxy"].image
│
│
│ [WARNING] Running terraform apply again will remove the kubernetes add-on and attempt to create it again effectively purging previous add-on configuration
│
│   with module.eks-infra-common-components.aws_eks_addon.kube_proxy,
│   on .terraform\modules\eks-infra-common-components\main.tf line 260, in resource "aws_eks_addon" "kube_proxy":
│  260: resource "aws_eks_addon" "kube_proxy" {
```

## Update kubeconfig with AWSCLI

Elastic Kubernetes Service leverages AWS IAM roles and users to extend the default Kubernetes RBAC security mechanism. The role currently authorized via okta-awscli must have the correct permissions associated.

Logging in to kubernetes is done via the aws cli command line. The following command executes kubernetes login and creates the context using the currently active aws credentials.

```shell
## Create Update kubeconfig
## Must have authenticated with okta-awscli
aws eks update-kubeconfig --name Ops360EKSCluster
```
