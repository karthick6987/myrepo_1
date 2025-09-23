variable "address_space" {
  type = list(string)
  default = ["10.0.0.0/16"]
}

variable "address_prefixes" {
  type = list(number)
  default = ["10.0.2.0/28"]
}

variable "Users_Names" {
  type = list(string)
  default = ["karthick","deepika","Agarshan"]
}

variable "destination_port" {
  type = list(number)
  default = ["3389","8080","443"]
}

variable "destination_address_prefix" {
   type = list(string)
  default = ["10.0.2.4","10.0.2.5","10.0.2.6"]
}

variable "network_interface" {
  type = list(string)
  default = [ "APP-NIC1","APP-NIC2","APP-NIC3" ]
}

variable "virtual_machine" {
  type = list(string)
  default = ["APPVM1","APPVM2","APPVM3"]
}

variable "datadisk" {
  type = list(string)
  default = ["Appdisk1","Appdisk2","Appdisk3",]
}

variable "PublicIP_name"{
type=list(string)
default = [ "AppPublicIP1","AppPublicIP2","AppPublicIP3"]
}

variable "tags_PublicIP" {
  type = map(string)
  default = {
    environment = "Production"
    opco= "karthick"
  }
}

variable "tags_managed_disk" {
   type = map
  default = { 
    environment = "staging"
    opco= "karthick"
    Createddate= 05092025
    }
}

variable "tags_network_security_group" {
  type = object({ruleID = number,opco=string})
default = {
   ruleID = 6987, opco= "karthick"
}
}

output "public_ip" {
  value = azurerm_public_ip.App_PublicIP_rb[*].ip_address
}

output "VM_names" {
  value = values(azurerm_windows_virtual_machine.AppVM_rb)[*].name
}

variable "tags_network_security_group" {
    type = object({opco = string,rule=number})
  default = {  
  ruleID = 6987
  opco= "karthick"
  }
}
