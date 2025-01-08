# This is where you put your resource declaration
data "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "zabbix" {
  repository = "https://zabbix-community.github.io/helm-zabbix"
  chart      = "zabbix"
  version    = var.helm_chart_version

  name      = "zabbix"
  namespace = data.kubernetes_namespace.this.metadata[0].name
}
