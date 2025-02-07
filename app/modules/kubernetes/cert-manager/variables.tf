# This is where you put your variables declaration

variable "email" {
  type        = string
  description = "(Required) Sets the email address for claim validation"
}

variable "namespace" {
  type        = string
  default     = "cert-manager"
  description = "(Optional) Name of the kubernetes namespace. Defaults to `cert-manager`."
}

variable "solvers" {
  type        = list(map(any))
  default     = [
    {
      http01 = {
        ingress = {
          class = "nginx"
        }
      }
    }
  ]
  description = "(Optional) Defines the possible solver configurations for LetsEncrypt"
}

variable "version" {
  type        = string
  default     = "1.17.0"
  description = "(Optional) Version number of the cert-manager Helm Chart."
}


