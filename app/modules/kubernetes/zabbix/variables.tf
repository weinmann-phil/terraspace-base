# This is where you put your variables declaration
variable "namespace" {
  type        = string
  description = "(Required) The name for the kubernetes namespace"
}

variable "helm_char_version" {
  type        = string
  default     = "6.1.2"
  description = "(Optional) The semantic version of the Zabbix Helm Chart"
}
