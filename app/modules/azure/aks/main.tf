# This is where you put your resource declaration
locals {
  tags = merge(var.tags, {
    managed_by     = "OpenTofu"
    module_name    = "azure/aks"
    module_version = "v0.0.1"
    environment    = var.environment
  })
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}



resource "azurerm_kubernetes_cluster" "this" {
  # General configuration
  name                  = coalesce(var.name, "aks-${var.prefix}-${var.environment}")
  location              = coalesce(var.location, data.azurerm_resource_group.this.location)
  resource_group_name   = data.azurerm_resource_group.this.name
  azure_policy_enabled  = var.enable_azure_policy
  tags                  = local.tags
  sku_tier              = var.sku_tier

  dynamic "identity" {
    for_each = var.service_principal.enabled ? [] : ["managed_identity"]

    content {
      type         = var.azure_managed_identity.type
      identity_ids = var.azure_managed_identity.type == "UserAssigned" ? var.azure_managed_identity.identity_ids : []
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
  dns_prefix                       = var.private_cluster ? null : var.dns_prefix
  dns_prefix_private_cluster       = var.private_cluster ? var.dns_prefix : null
  oidc_issuer_enabled              = var.enable_oidc_issuer

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
    # critical_addons_enabled
    orchestrator_version        = var.default_node_pool.orchestrator_version
    os_disk_size_gb             = var.default_node_pool.os_disk_size_gb
    os_disk_tyipe                = var.default_node_pool.os_disk_type  
  }

  dynamic "auto_scaler_profile" {
    for_each = var.auto_scaler_profile.enabled ? ["auto_scaler_profile"] : []

    content {
      balance_similar_node_groups                   = var.auto_scaler_profile.balance_similar_node_groups
      daemonset_eviction_for_empty_nodes_enabled    = var.auto_scaler_profile.daemonset_eviction_for_empty_nodes_enabled
      daemonset_eviction_for_occupied_nodes_enabled = var.auto_scaler_profile.daemonset_eviction_for_occupied_nodes_enabled
      expander                                      = var.auto_scaler_profile.expander
      ignore_daemonsets_utilization_enabled         = var.auto_scaler_profile.ignore_daemonsets_utilization_enabled
      max_graceful_termination_sec                  = var.auto_scaler_profile.max_graceful_termination_sec
      max_node_provisioning_time                    = var.auto_scaler_profile.max_node_provisioning_time
      max_unready_nodes                             = var.auto_scaler_profile.max_unready_nodes
      new_pod_scale_up_delay                        = var.auto_scaler_profile.new_pod_scale_up_delay
      scale_down_delay_after_add                    = var.auto_scaler_profile.scale_down_delay_after_add
      scale_down_delay_after_failure                = var.auto_scaler_profile.scale_down_delay_after_failure
      scan_interval                                 = var.auto_scaler_profile.scan_interval
      scale_down_unneded                            = var.auto_scaler_profile.scale_down_unneded
      scale_down_unready                            = var.auto_scaler_profile.scale_down_unready
      scale_down_utilization_threshold              = var.auto_scaler_profile.scale_down_utilization_threshold
      empty_bulk_delete_max                         = var.auto_scaler_profile.empty_bulk_delete_max
      skip_nodes_with_system_pods                   = var.auto_scaler_profile.skip_nodes_with_system_pods
      skip_nodes_with_local_storage                 = var.auto_scaler_profile.skip_nodes_with_local_storage
    }
  }

  network_profile {
    network_plugin      = var.network_profile.network_plugin
    network_policy      = var.network_profile.network_policy
    network_mode        = var.network_profile.network_mode
    dns_service_ip      = var.network_profile.dns_service_ip
    network_data_plane  = var.network_profile.network_data_plane
    network_plugin_mode = var.network_profile.network_plugin_mode
    outbound_type       = var.network_profile.outbound_type
    load_balancer_profile {
      outbound_ip_address_ids = [var.outbound_ip_address_ids]
    }
  }


  api_server_access_profile {
    authorized_ip_ranges = var.api_server_authorized_ip_ranges
  }

  dynamic "" {
    for_each = var.azure_ad_rbac.enabled ? ["ad_rbac_enabled"] : []

    content {
      azure_rbac_enabled     = var.azure_ad_rbac.enabled
      tenant_id              = var.tenant_id
      admin_group_object_ids = var.azure_ad_rbac.admin_group_object_ids
    }
  }
}

data "azurerm_resources" "cluster_node_resource_group_vnets" {
  type                = "Microsoft.Network/virtualNetworks"
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
}

data "azurerm_virtual_network" "cluster_vnet" {
  name                = data.azurerm_resources.cluster_node_resource_group_vnets.resources[0].name
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
}

data "azurerm_subnet" "cluster_vnet_subnet" {
  name                 = data.azurerm_virtual_network.cluster_vnet.subnets[0]
  virtual_network_name = data.azurerm_virtual_network.cluster_vnet.name
  resource_group_name  = azurerm_kubernetes_cluster.this.node_resource_group
}
