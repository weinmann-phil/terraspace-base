# This is where you put your outputs declaration
output "acr_module" {
  description = "Obect with entirety of valid container registry outputs."
  value       = azurerm_container_registry.main
}

output "admin_enabled" {
  description = "The ID of the Container Registry."
  value       = azurerm_container_registry.main.admin_enabled
}

output "admin_password" {
  description = "The Password associated with the Container Registry Admin account - if the admin account is enabled."
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
}

output "admin_username" {
  description = "The Username associated with the Container Registry Admin account - if the admin account is enabled."
  value       = azurerm_container_registry.main.admin_username
}

output "anonymous_pull_enabled" {
  description = "The ID of the Container Registry."
  value       = azurerm_container_registry.main.anonymous_pull_enabled
}

output "data_endpoint_enabled" {
  description = "Whether to enable dedicated data endpoints for this Container Registry"
  value       = azurerm_container_registry.main.data_endpoint_enabled
}

output "encryption" {
  description = "An encryption block as documented below."
  value       = azurerm_container_registry.main.encryption
}

output "export_policy_enabled" {
  description = "Boolean value that indicates whether export policy is enabled."
  value       = azurerm_container_registry.main.export_policy_enabled
}

output "id" {
  description = "The ID of the Container Registry."
  value       = azurerm_container_registry.main.id
}

output "location" {
  description = "Specifies the supported Azure location where the resource exists."
  value       = azurerm_container_registry.main.location
}

output "login_server" {
  description = "The URL that can be used to log into the container registry."
  value       = azurerm_container_registry.main.login_server
}

output "name" {
  description = "Specifies the name of the Container Registry."
  value       = azurerm_container_registry.main.name
}

output "network_rule_bypass_option" {
  description = "Whether to allow trusted Azure services to access a network restricted Container Registry"
  value       = azurerm_container_registry.main.network_rule_bypass_option
}

output "network_rule_set" {
  description = "Network configuration for IPv4 block."
  value       = azurerm_container_registry.main.network_rule_set
}

output "public_network_access_enabled" {
  description = "The ID of the Container Registry."
  value       = azurerm_container_registry.main.public_network_access_enabled
}

output "quarantine_policy_enabled" {
  description = "Boolean value that indicates whether quarantine policy is enabled."
  value       = azurerm_container_registry.main.quarantine_policy_enabled
}

output "resource_group_name" {
  description = "The name of the resource group in which to create the Container Registry. "
  value       = azurerm_container_registry.main.resource_group_name
}

output "retention_policy" {
  description = "A retention_policy block as documented below."
  value       = azurerm_container_registry.main.retention_policy
}

output "sku" {
  description = "The SKU name of the container registry."
  value       = azurerm_container_registry.main.sku
}

output "trust_policy" {
  description = "Boolean value that indicates whether the policy is enabled."
  value       = azurerm_container_registry.main.trust_policy
}

output "zone_redundancy_enabled" {
  description = "Whether zone redundancy is enabled for this Container Registry"
  value       = azurerm_container_registry.main.zone_redundancy_enabled
}
