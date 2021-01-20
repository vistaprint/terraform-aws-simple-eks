terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 1.13"
    }    
  }
}
