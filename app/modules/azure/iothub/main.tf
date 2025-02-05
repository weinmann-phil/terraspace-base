# This is where you put your resource declaration
locals {
  tags = merge(var.tags, {
    managed_by     = "OpenTofu"
    module_name    = "azure/iothub"
    module_version = "v0.0.1"
    environment    = var.environment
  })
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_iothub" "this" {
  name                = coalesce(var.iothub_name, "iothub-${var.prefix}-${var.environment}")
  resource_group_name = data.azurerm_resource_group.this.name
  location            = coalesce(var.location, data.azurerm_resource_group.this.location)
  
  local_authentication_enabled = var.enable_local_authentication

  sku {
    name     = var.sku.name
    capacity = var.sku.capacity
  }
  
  dynamic "endpoint" {
    for_each = length(var.endoints) > 0 ? ["endpoints"] : []

    contents = {
      type                       = each.type
      name                       = each.name
      authentication_type        = each.authentication_type
      identity_id                = each.identity_id
      endpoint_uri               = each.uri
      entity_path                = each.entity_path
      connection_string          = each.connection_string
      batch_frequency_in_seconds = each.batch_frequency_in_seconds
      max_chunk_size_in_bytes    = each.max_chunk_size_in_bytes
      container_name             = each.container_name
      encoding                   = each.encoding
      file_name_format           = each.file_name_format
      resource_group_name        = each.resource_group_name
    }
  }

  dynamic "route" {
    for_each = length(var.routes) > 0 ? ["routes"] : []

    contents = {
      name           = each.name
      source         = each.source
      condition      = each.condition
      endpoint_names = each.endpoint_name
      enabled        = each.enabled
    }
  }

  dynamic "enrichment" {
    for_each = length(var.enrichments) > 0 ? ["enrichments"] : []

    contents = {
      key            = each.key
      value          = each.value
      endpoint_names = each.endpoint_names
    }
  }

  dynamic "cloud_to_device" {
    for_each = length(var.connections) > 0 ? ["connections"] : []

    contents = {
      max_delivery_count = each.max_delivery_count
      default_ttl        = each.default_ttl
      feedback {
        time_to_live       = each.time_to_live
        max_delivery_count = each.max_delivery_count
        lock_duration      = each.lock_duration
      }
    }
  }

  tags = {
    local.tags
  }
}
