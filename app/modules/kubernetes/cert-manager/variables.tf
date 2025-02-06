# This is where you put your variables declaration
variable "namespace" {
  type        = string
  default     = "cert-manager"
  description = "(Optional) Name of the kubernetes namespace. Defaults to `cert-manager`."
}

variable "version" {
  type        = string
  default     = "1.17.0"
  description = "(Optional) Version number of the cert-manager Helm Chart."
}
