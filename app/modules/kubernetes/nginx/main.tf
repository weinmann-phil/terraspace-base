# This is where you put your resource declaration
locals {
  labels = {
    managed_by     = "OpenTofu"
    module_name    = "kubernetes/nginx"
    module_version = "v0.0.1"
    environment    = var.environment
  }
}

data "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "nginx_ingress" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  name       = "nginx-ingress"
  chart      = "ingress-nginx"
  version    = var.version
  namespace  = data.kubernetes_namespace.this.metadata[0].name

  values = concat(
    var.use_spot_affinity
    ? [templatefile("${path.module}/configs/helm/nginx_ingress/azure_spot_nodes.tpl.yml", {})]
    : [],
  )

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
  # Custom settings for nginx
  # see https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/
  set {
    name  = "controller.config.proxy-body-size"
    value = "50m" # File uploads
  }
  set {
    name  = "controller.config.large-client-header-buffers"
    value = "4 32k"
  }
  set {
    name  = "controller.config.proxy-buffer-size"
    value = "32k" # Max. Cookies, etc.
  }
  # Required with "controller.allowSnippetAnnotations"
  # https://github.com/kubernetes/ingress-nginx/issues/12656
  set {
    name  = "controller.config.annotations-risk-level"
    value = "Critical"
  }
  set {
    name  = "controller.allowSnippetAnnotations"
    value = "true"
  }
  set {
    name  = "controller.configMapNamespace"
    value = data.kubernetes_namespace.this.metadata[0].name
  }
  set {
    name  = "controller.tcp.configMapNamespace"
    value = kubernetes_namespace.nginx_ingress.metadata[0].name
  }
  set {
    name  = "controller.ingressClassResource.default"
    value = "true"
  }
}


