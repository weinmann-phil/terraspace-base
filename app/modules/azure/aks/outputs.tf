# This is where you put your outputs declaration
output "kube_config" {
  value       = azurerm_kubernetes_cluster.this.kube_config
  description = "Exports the kube_config of the created cluster."
}

output "kube_config_raw" {
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  description = "Exports the raw kubernetes configuration of the cluster."
}

output "kube_admin_config" {
  value       = azurerm_kubernetes_cluster.this.kube_admin_config
  description = "Exports the administrative kubernetes configuration of the cluster."
}

output "kube_admin_config_raw" {
  value       = azurerm_kubernetes_cluster.this.kube_admin_config_raw
  description = "Exports the raw administrative kubernetes configuration of the cluster."
}

output "id" {
  value       = azurerm_kubernetes_cluster.this.id
  description = "Exports the resource id of the cluster"
}

output "fqdn" {
  value       = azurerm_kubernetes_cluster.this.fqdn
  description = "Exports the FQDN of the cluster"
}

output "node_resource_group_name" {
  value       = azurerm_kubernetes_cluster.this.node_resource_group
  description = "Exports the support plan of the cluster."
}

output "oidc_issuer_url" {
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
  description = "Exports the OIDC issuer url"
}

output "cluster_vnet_id" {
  value       = ""
}
