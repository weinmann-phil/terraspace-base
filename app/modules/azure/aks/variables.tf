# This is where you put your variables declaration
variable "auto_scaler_profile" {
  type        = object({
    enabled                                       = bool
    balance_similar_node_groups                   = bool
    daemonset_eviction_for_empty_nodes_enabled    = bool
    daemonset_eviction_for_occupied_nodes_enabled = bool
    expander                                      = string
    ignore_daemonsets_utilization_enabled         = bool
    max_graceful_termination_sec                  = number
    max_node_provisioning_time                    = string
    max_unready_nodes                             = number
    max_unready_percentage                        = number
    new_pod_scale_up_delay                        = string
    scale_down_delay_after_add                    = string
    scale_down_delay_after_delete                 = string
    scale_down_delay_after_failure                = string
    scan_interval                                 = string
    scale_down_unneded                            = string
    scale_down_unready                            = string
    scale_down_utilization_threshold              = number
    empty_bulk_delete_max                         = number
    skip_nodes_with_system_pods                   = bool
    skip_nodes_with_local_storage                 = bool
  })
  default     = {
    enabled                                       = true
    balance_similar_node_groups                   = false
    daemonset_eviction_for_empty_nodes_enabled    = false
    daemonset_eviction_for_occupied_nodes_enabled = true
    expander                                      = "priority"
    ignore_daemonsets_utilization_enabled         = false
    max_graceful_termination_sec                  = 600
    max_node_provisioning_time                    = "15m"
    max_unready_nodes                             = 3
    max_unready_percentage                        = 45
    new_pod_scale_up_delay                        = "10s"
    scale_down_delay_after_add                    = "10m"
    scale_down_delay_after_delete                 = "10s"
    scale_down_delay_after_failure                = "3m"
    scan_interval                                 = "10s"
    scale_down_unneded                            = "10m"
    scale_down_unready                            = "20m"
    scale_down_utilization_threshold              = 0.5
    empty_bulk_delete_max                         = 10
    skip_nodes_with_system_pods                   = true
    skip_nodes_with_local_storage                 = true
  }
  description = "(Optional) Configures the auto scaler profiler"
}

variable "azure_managed_identity" {
  type        = object({
    type         = string
    identity_ids = list(string)
  })
  default     = {
    type         = "UserAssigned"
    identity_ids = []
  }
  description = "(Optional) Defines managed identity."
}

variable "default_node_pool" {
  type        = object({
    name                        = string
    temporary_name_for_rotation = string
    node_count                  = number
    vm_size                     = string
    auto_scaling_enabled        = bool
    max_pods                    = number
    min_count                   = number
    max_count                   = number
    orchestrator_version        = string
    os_disk_size_gb             = number
    os_disk_type                = string
  })
  default     = {
    name                        = "system"
    temporary_name_for_rotation = "metsys"
    node_count                  = 1
    vm_size                     = "Standard_B2s"
    auto_scaling_enabled        = false
    max_pods                    = 250
    min_count                   = 1
    max_count                   = 3
    orchestrator_version        = "1.32.0"
    os_disk_size_gb             = 30
    os_disk_type                = "Ephemeral"
  }
  description = "(Optional) Defines the system node pool of the cluster."  

  validation {
    condition     = var.default_node_pool.auto_scaling_enabled == false || (
      var.default_node_pool.min_count != null 
      && var.default_node_pool.max_count != null
    )
    error_message = "If auto_scaling_enabled is true, then provide values for `min_count` and `max_count`."
  }

  validation {
    condition     = var.default_node_pool.orchestrator_version == var.kubernetes_version
    error_message = "Please make sure that the orchestrator version is the same as the kubernetes version."
  }
}

variable "dns_prefix" {
  type        = string
  description = "(Required) Sets a unique DNS prefix for the official Azure URL. Possible values must begin and end with an alphanumeric character and be 1 and 54 characters in length."

  validation {
    condition     = length(var.dns_prefix) > 1 && length(var.dns_prefix) <= 54
    error_message = "The length "
  }

  validation {
    condition     = can(regex("^\\w+$", var.dns_prefix))
    error_message = "The DNS prefix can only contain alphanumeric characters."
  }
}

variable "enable_azure_policy" {
  type        = bool
  default     = false
  description = "(Optional) Sets the possibility to extend Azure policies."
}

variable "enable_http_app_routing" {
  type        = bool
  default     = false
  description = "(Optional) Sets the possibility for HTTP routing with Apps."
}

variable "enable_oidc_issuer" {
  type        = bool
  default     = true
  description = "(Optional) Enables OIDC issuer."
}

variable "enable_workload_identity" {
  type        = bool
  default     = true
  description = "(Optional) Enables Workload Identities to be used within cluster"
}

variable "environement" {
  type        = string
  default     = "dev"
  description = "(Optional) Sets an environment short name for resource."
}

variable "kubernetes_version" {
  type        = string
  description = "(Required) Sets the version of Kubernetes"
}

variable "location" {
  type        = string
  description = "(Required) Defines the location of the resource"
}

variable "name" {
  type        = string
  default     = null
  description = "(Optional) Sets the resource name of the kubernetes cluster"
}

variable "network_profile" {
  type        = object({
    network_plugin      = string
    network_policy      = string
    network_mode        = string
    dns_service_ip      = string
    network_data_plane  = string
    network_plugin_mode = string
    outbound_type       = string
  })
  default     = {
    network_plugin      = "azure"
    network_policy      = "azure"
    network_mode        = "bridge"
    dns_service_ip      = ""
    network_data_plane  = "azure"
    network_plugin_mode = "overlay"
    outbound_type       = "loadBalancer"
  }
  description = "(Optional) Defines the network configuration for the cluster"
}

variable "outbound_ip_address_ids" {
  type        = string
  description = "(Required) Defines a list of valid outbound IPs"
}

variable "prefix" {
  type        = string
  default     = null
  description = "(Optional) Sets the name base for the cluster name. Required if var.name is `null`."

  validation {
    condition = (
      var.name == null && var.prefix == null
    )
    error_message = "Variable `prefix` cannot be `null`, if variable `name` is `null`."
  }
}

variable "private_cluster" {
  type        = bool
  default     = false
  description = "(Optional) Sets the option to build a private cluster."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Defines the name of a resource group."
}

variable "service_principal" {
  type        = object({
    enabled       = bool
    client_id     = string
    client_secret = string
  })
  default     = {
    enabled       = false
    client_id     = ""
    client_secret = ""
  }
  description = "(Optional) Sets access with service principal."
}

variable "sku_tier" {
  type        = string
  default     = "Free"
  description = "(Optional) Chooses one of the available tiers specific to the resource. Possible values are `Free`, `Standard` and `Premium`."

  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.sku_tier)
    error_message = "Could find the requested SKU tier. Please choose either `Free`, `Standard`, or `Premium`."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) Defines custom tags for the resource"
}


