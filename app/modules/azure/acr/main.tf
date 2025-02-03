# This is where you put your resource declaration
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_container_registry" "this" {
  name                = coalesce(var.registry_name, trim("acr${var.prefix}", "-"))
  resource_group_name = data.azurerm_resource_group.this.name
  location            = coalesce(var.location, data.azurerm_resource_group.this.location)
  sku                 = var.sku
  admin_enabled       = var.enable_administrative_access

  public_network_access_enabled = var.enable_public_network_access
  network_rule_bypass_option    = var.network_rule_bypass_option

  data_endpoint_enabled = var.enable_data_endpoint

  dynamic "trust_policy" {
    for_each = var.enable_trust_policy ? ["trust_policy_enabled"] : []

    content {
      enabled = var.enable_trust_policy
    }
  }

  # Premium tier specific definitions
  dynamic "network_rule_set" {
    for_each = length(concat(var.allowed_cidrs, var.allowed_subnets)) > 0 ? ["network_rule_set_enabled"] : []

    content {
      default_action = "Deny"
      dynamic "ip_rule" {
        for_each = var.allowed_cidrs

        content {
          action   = "Allow"
          ip_range = "${ip_rule.value}/32"
        }
      }

      dynamic "virtual_network" {
        for_each = var.allowed_subnets

        content {
          action    = "Allow"
          subnet_id = virtual_network.value
        }
      }
    }
  }

  dynamic "retention_policy" {
    for_each = var.enable_image_retention ? ["image_retention_enabled"] : []

    content {
      enabled = var.enable_image_retention
      days    = var.retention_period
    }
  }

  tags = var.tags
}
