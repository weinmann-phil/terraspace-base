# This is where you put your variables declaration
variable "additional_config" {
  type        = object({
    affinity_key      = string
    affinity_values   = list(string)
    tolerations_key   = string
    tolerations_value = string
  })
  default     = {}
  description = "(Optional) Sets values for affinities and tolerations."

  validation {
    condition     = contains(["lifecycle", "kubernetes.azure.com/scalesetpriority", "cloud.google.com/gke-spot"], var.additional_config.affinity_key)
    error_message = "The affinity key has to be either `lifecycle` (AWS), `kubernetes.azure.com/scalesetpriority` (Azure), or `cloud.google.com/gke-spot` (Google Cloud)."
  }

  validation {
    condition     = contains(["lifecycle", "kubernetes.azure.com/scalesetpriority", "cloud.google.com/gke-spot"], var.additional_config.tolerations_key)
    error_message = "The tolerations key has to be either `lifecycle` (AWS), `kubernetes.azure.com/scalesetpriority` (Azure), or `cloud.google.com/gke-spot` (Google Cloud)."
  }
}

variable "namespace" {
  type        = string
  description = "(Required) Defines the kubernetes namespace for the resources."
}

variable "version" {
  type        = string
  default     = "4.12.0"
  description = "(Optional) Sets the version of the Helm chart. Defaults to 4.12.0 (latest as of Dec 2024)."
}
