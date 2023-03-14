# Ops360 - Core UI Terraform Scripts
> Terraform scripts designed for a Capital Group development environment.

### Prerequisites

- EKS Cluster
  
### Usage
This module is intended to be used as a sub-module to the parent script. As such, it is missing the provider configurations required.

## What it does
The module deploys the ui service.

- Deploys the service using Helm

### TODO and Known Issues
- Expose the path prefix and nginx config file