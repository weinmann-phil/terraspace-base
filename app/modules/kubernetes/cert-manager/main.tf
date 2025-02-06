# This is where you put your resource declaration
locals {
  labels = {
    managed_by = "OpenTofu"
  }
}

data "kubernetes_namespace" "this" {
  metadata = {
    name = var.namespace
  }
}


resource "helm_release" "cert_manager" {
  repository = "https://charts.jetstack.io"
  name       = "cert-manager"
  chart      = "cert-manager"
  version    = var.version #"1.13.2"
  namespace  = data.kubernetes_namespace.this.metadata[0].name
  set {
    name  = "crds.enabled"
    value = "true"
  }
  set {
    name  = "crds.keep"
    value = "true"
  }
  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  set {
    name  = "serviceAccount.automountServiceAccountToken"
    value = "true"
  }
}
