output "vm_id" {
  description = "ID of the Virtual Machine"
  value       = azurerm_windows_virtual_machine.vm.id
}

output "nic_id" {
  description = "ID of the Network Interface"
  value       = azurerm_network_interface.vm_nic.id
}
