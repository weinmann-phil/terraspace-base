# This is where you put your resource declaration
locals {
  labels = {
    managed_by     = "OpenTofu"
    module_name    = "kubernetes/cert-manager"
    module_version = "v0.0.1"
    environment    = var.environment

  }
}

data "kubernetes_namespace" "this" {
  metadata {
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

# =============================================================================
# TLS Base Configuration
# =============================================================================
resource "kubernetes_manifest" "letsncrypt_cluster_issuer" {
  for_each = toset(["staging", "production"])
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-${each.key}"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = var.email
        privateKeySecretRef = {
          name = "letsencrypt-${each.key}"
        }
        solvers = var.solvers
      }
    }
  }
}
