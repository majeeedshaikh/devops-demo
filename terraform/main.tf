terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.9"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.7"
    }
  }
}

# Point to your local k3d kubeconfig
provider "kubernetes" {
  config_path = "${path.module}/../devops-kubeconfig.yaml"
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/../devops-kubeconfig.yaml"
  }
}

# 1) Install nginx‐ingress via Helm
resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  create_namespace = true
}

# 2) Deploy your ConfigMap, Secret, Deployment, Service & Ingress
resource "kubernetes_manifest" "app_resources" {
  for_each = fileset("${path.module}/../k8s", "*.yaml")
  manifest = yamldecode(file("${path.module}/../k8s/${each.key}"))
}
