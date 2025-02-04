# This is where you put your resource declaration
locals {
  tags = merge(var.tags, {
    managed_by     = "OpenTofu"
    module_name    = "azure/mysql"
    module_version = "v0.0.1"
    environment    = var.environment
  }) 
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_mysql_flexible_server" "this" {
  name                = coalesce(var.name, "mysql-${var.prefix}-${var.environment}")
  resource_group_name = data.azurerm_resource_group.this.name
  location            = coalesce(var.location, data.azurerm_resource_group.this.location)

  sku_name                     = var.sku_name
  zone                         = var.availability_zone
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  storage {
    iops              = var.storage.iops
    size_gb           = var.storage.size_gb
    auto_grow_enabled = var.storage.auto_grow_enabled
  }

  administrator_login    = var.administrator_login != null ? var.administrator_login : "mysqladm"
  administrator_password = var.administrator_password
  version                = var.mysql_version
 
  lifecycle {
    ignore_changes = [
      zone,
    ]
  }
}

resource "azurerm_mysql_flexible_server_firewall_rule" "allowed_ips" {
  count = length(var.allowed_ip_ranges)

  name                = "allowed-ip-${count.index}"
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_mysql_flexible_server.server.name
  start_ip_address    = var.allowed_ip_ranges[count.index].from
  end_ip_address      = var.allowed_ip_ranges[count.index].to
  depends_on = [
    azurerm_mysql_flexible_server.server
  ]
}

resource "azurerm_mysql_flexible_server_configuration" "this" {
  for_each = { for config in var.configurations : config["key"] => config }

  name                = each.value.key
  resource_group_name = azurerm_mysql_flexible_server.server.resource_group_name
  server_name         = azurerm_mysql_flexible_server.server.name
  value               = each.value.value
}
