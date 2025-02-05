# This is where you put your variables declaration
variable "enable_local_authentication" {
  type        = bool
  default     = false
  description = "(Optional) Enables local authentication. Defaults to `false`."
}

variable "endpoints" {
  type        = list(object({
    type                       = string
    name                       = string
    authentication_type        = string
    identity_id                = string
    uri                        = string
    entity_path                = string
    connection_string          = string
    batch_frequency_in_seconds = number
    max_chunk_size_in_bytes    = number
    container_name             = string
    encoding                   = string
    file_name_format           = string
    resource_group_name        = string
  }))
  default     = []
  description = "(Optional) Defines an endpoint for the IotHub."

  validation {
    condition     = ( 
      alltrue([ for instance in var.endpoints : (  
        contains(["AzureIotHub.StorageContainer", "AzureIotHub.ServiceBusQueue", "AzureIotHub.ServiceBusTopic", "AzureIotHub.EventHub"], instance.type))
      )])
    )
    error_message = "The variable endpoint.type must be one of the following resource definitions: `AzureIotHub.StorageContainer`, `AzureIotHub.ServiceBusQueue`, `AzureIotHub.ServiceBusTopic`, or `AzureIotHub.EventHub`."
  }

  validation {
    condition     = (
      alltrue([ for instance in var.endpoints : (
        !contains(["events", "operationsMonitoringEvents", "fileNotification", "$default"], instance.name)
      )])
    )
    error_message = "Avoid using one of the following reserved names: `events`, `operationsMonitoringEvents`, `fileNotification`, or `$default`."
  }

  validation {
    condition     = (
      alltrue([ for instance in var.endpoints : (
        contains(["keyBased", "identityBased"], instance.authentication_type))
      )])
    )
    error_message = "The variable endpoint.authentication_type can either be `keyBased` or `identityBased`."
  }

  validation {
    condition     = (
      alltrue([ for instance in var.endpoints : (
        (instance.type != "AzureIotHub.StorageContainer" && instance.authentication_type == "identityBased") && var.endpoint.endpoint_uri != null
      )])
    )
    error_message = "The variable endpoint.uri cannot be null, if authentication_type is `identityBased` and endpoint type is not AzureIotHub.StorageContainer."
  }

  validation {
    condition     = (
      alltrue([ for instance in var.endpoints : (
        (var.endpoint.type != "AzureIotHub.StorageContainer" && var.endpoint.authentication_type == "identityBased") && var.endpoint.endpoint_path != null
      )])
    )
    error_message = "The variable endpoint.entity_path cannot be null, if authnetication_type is `identityBased` and endpoint type is not AzureIotHub.StorageContainer."
  }

  validation {
    condition     = (
      alltrue([ for instance in var.endpoints : (
        var.endpoint.authentication_type == "keyBased" && var.endpoint.connection_string != null
      )])
    )
    error_message = "The variable endpoint.connection_string cannot be null, if the authentication type is `keyBased`."
  }

  validation {
    condition     = (
      alltrue([ for instance in var.endpoints : (
        var.endpoint.batch_frequency_in_seconds >= 60 && var.endpoint.batch_frequency_in_seconds <= 270
      )])
    )
    error_message = "The frequency has to be a value between 60 and 270 seconds."
  }

  validation {
    condition     = (
      alltrue([ for instance in var.endpoints : (
        var.endpoint.max_chunk_size_in_bytes >= 10485760 && var.endpoint.max_chunk_size_in_bytes <= 524288000
      )])
    )
    error_message = "Please select a value between 10485760 (10MB) and 524288000 (500MB) bytes."
  }

  validation {
    condition     = (
      alltrue([ for instance in var.endpoints : (
        contains(["Avro", "AvroDeflate", "JSON"], var.endpoint.encoding)
      )])
    )
    error_message = "Valid values for endpoint.encoding are `Avro`, `AvroDeflate`, or `JSON`."
  }
}

variable "environment" {
  type        = string
  default     = "development"
  description = "(Optional) Defines the name of the resource environment. Defaults to `development`."
}

variable "iothub_name" {
  type        = string
  default     = null
  description = "(Optional) Sets the name of Azure IotHub"
}

variable "location" {
  type        = string
  default     = null
  description = "(Optional) Sets the location of the resource. Defaults to the location of the resource group."
}

variable "sku" {
  type        = object({
    name     = string
    capacity = string
  })
  default     = {
    name     = "F1"
    capacity = "1"
  }
  description = "(Optional) Defines the SKU data of the iothub."

  validation {
    condition = (
      contains(["F1", "B1", "B2", "B3", "S1", "S2", "S3"], var.sku.name)     
    )
    error_message = "SKU name must be one of the following values: `F1`, `B1`, `B2`, `B3`, `S1`, `S2`, `S3`."
  }
}


