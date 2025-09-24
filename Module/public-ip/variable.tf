variable "name" {
  description = "Name of the Public IP"
  type        = string
}

variable "location" {
  description = "Azure region where Public IP will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "allocation_method" {
  description = "Defines the allocation method for the Public IP. Possible values are Static or Dynamic"
  type        = string
  default     = "Static"
}

variable "sku" {
  description = "The SKU of the Public IP. Possible values are Basic or Standard"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
