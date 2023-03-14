terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.14.0"
    }
  }
}

# Install kuberenetes secrets
resource "helm_release" "bpm_admin_ui" {
  name              = var.service_name
  chart             = "../helm/bpm-admin-ui"
  dependency_update = true
  create_namespace  = true
  reuse_values      = true
  namespace         = var.k8s_namespace

  set {
    name  = "image"
    value = var.image
  }

  set {
    name  = "awsRegion"
    value = var.aws_region
  }

  set {
    name  = "namespace"
    value = var.k8s_namespace
  }

  set {
    name  = "routeHost"
    value = var.route53_base_domain
  }

  set {
    name  = "serviceCpu"
    value = var.k8s_cpu_limit
  }

  set {
    name  = "serviceMemory"
    value = var.k8s_memory_limit
  }
}
