terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5, < 6"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2, < 3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2, < 3"
    }
  }
}
