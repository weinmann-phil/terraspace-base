# This is where you put your resource declaration
locals {
  annotations = {
    managed_by     = "OpenTofu"
    module_name    = "kubernetes/kube-prometheus-stack"
    module_version = "v0.0.1"
    environment    = var.environment
  }
}

data "kubernetes_namespace" "this" {
  metadata {
    name = var.name
  }
}

resource "helm_release" "this" {
  repository = "https://prometheus-community.github.io/helm-charts"
  name       = "kube-prometheus-stack"
  chart      = "kube-prometheus-stack"
  version    = var.version
  namespace  = data.kubernetes_namespace.this.metadata[0].name

  set {
    name  = "crds.podAnnotations"
    value = local.annotations
  }

  set {
    name  = ""
    value = ""
  }
}
