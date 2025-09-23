variable "name" {
  description = "Name of the VM"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "size" {
  description = "VM size"
  type        = string
  default     = "Standard_F2"
}

variable "os_disk" {
  description = "Name of the OS disk"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "image_os" {
  description = "Windows Server SKU"
  type        = string
  default     = "2019-Datacenter"
}

variable "admin_username" {
  description = "Admin username for VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for VM"
  type        = string
  sensitive   = true
}
