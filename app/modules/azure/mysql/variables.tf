# This is where you put your variables declaration
variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "administrator_login" {
  type    = string
  default = null
}

variable "administrator_password" {
  type = string
}

variable "environment" {
  type        = string
  default     = "development"
  description = "(Optional) Names the environment of the resource"
}

variable "sku_name" {
  type    = string
  default = "B_Gen5_1"
}

variable "storage" {
  type        = object({
    iops              = number
    size_gb           = number
    auto_grow_enabled = bool
  })
  default     = {
    iops              = 360
    size_gb           = 5
    auto_grow_enabled = true
  }
  description = "(Optional) Defines storage options for DBMS"
}

variable "mysql_version" {
  type    = string
  default = "8.0"
}

variable "backup_retention_days" {
  type    = number
  default = 35
}

variable "geo_redundant_backup_enabled" {
  type    = bool
  default = false
}

variable "allowed_ip_ranges" {
  type = list(object({
    from = string
    to   = string
  }))
  default = []
}

variable "availability_zone" {
  type    = number
  default = 2
}

variable "configurations" {
  type = list(object({
    key   = string
    value = string
  }))
  default = []
}
