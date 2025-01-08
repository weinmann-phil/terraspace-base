# This is where you put your resource declaration
locals {
  tags = merge(var.tags, {
    managed_by  = "OpenTofu"
    module_name = "azure/aks"
  })
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "this" {
  # General configuration
  name                  = var.name
  location              = coalesce(var.location, data.azurerm_resource_group.this.location)
  resource_group_name   = data.azurerm_resource_group.this.name
  azure_policy_entables = var.enable_azure_policy
  tags                  = local.tags
  sku_tier              = var.sku_tier

  dynamic "identity" {
    for_each = var.service_principal.enabled ? [] : ["managed_identity"]

    content {
      type         = var.azure_managed_identity.type
      identity_ids = var.azure_managed_identity.type == "UserAssigned" ? var.azure_managed_identity.type : []
    }
  }

  dynamic "service_principle" {
    for_each = var.service_principal.enabled ? ["service_principal"] : []

    content {
      client_id     = var.service_principal.client_id
      client_secret = var.service_principal.client_secret
    }
  } 
  
  http_application_routing_enabled = var.enable_http_app_routing
  dns_prefix                 = var.private_cluster ? null : var.dns_prefix
  dns_prefix_private_cluster = var.private_cluster ? var.dns_prefix : null
  oidc_issuer_enabled = var.enable_oidc_issuer

  # Kubernetes configuration
  kubernetes_version        = var.kubernetes_version
  workload_identity_enabled = var.enable_workload_identity

  # Default nodepool
  default_node_pool {
    name                        = var.default_node_pool.name
    temporary_name_for_rotation = var.default_node_pool.temporary_name
    node_count                  = var.default_node_pool.node_count
    vm_size                     = var.default_node_pool.vm_size
    auto_scaling_enabled        = var.default_node_pool.enable_auto_scaling
    max_pods                    = var.default_node_pool.max_pods
    min_count                   = var.default_node_pool.min_count
    max_count                   = var.default_node_pool.max_count
    orchestrator_version        = var.default_node_pool.orchestrator_version
    os_disk_size_gb             = var.default_node_pool.os_disk_size_gb
    os_disk_type                = var.default_node_pool.os_disk_type  
  }
}
