output "vm_id" {
  description = "ID of the Virtual Machine"
  value       = azurerm_windows_virtual_machine.vm.id
}

output "nic_id" {
  description = "ID of the Network Interface"
  value       = azurerm_network_interface.vm_nic.id
}

output "public_ip" {
  description = "output of the public IP"
  value       = azurerm_windows_virtual_machine.vm.id
}
