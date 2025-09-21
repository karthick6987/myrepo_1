provider "azurerm" {
  features {}
  subscription_id = "a67cb678-0d1b-4bf0-97dc-521062a152cd"
}

#resource Group

data "azurerm_resource_group" "cloud_in_azure_rb" {
  name = "cloud_in_azure"
}

resource "azurerm_virtual_network" "AppNetwork_rb" {
  name                = "AppNetwork"
  address_space       = var.address_space
  location            = data.azurerm_resource_group.cloud_in_azure_rb.location
  resource_group_name = data.azurerm_resource_group.cloud_in_azure_rb.name
}

resource "azurerm_subnet" "Appsubnet-rb" {
  name                 = "Appsubnet"
  resource_group_name  = data.azurerm_resource_group.cloud_in_azure_rb.name
  virtual_network_name = azurerm_virtual_network.AppNetwork_rb.name
  address_prefixes     = var.address_prefixes
}

resource "azurerm_network_interface" "App_NIC_rb" {
  for_each = var.network_interface
  name                = each.value
  location            = data.azurerm_resource_group.cloud_in_azure_rb.location
  resource_group_name = data.azurerm_resource_group.cloud_in_azure_rb.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Appsubnet-rb.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Public Ip

resource "azurerm_public_ip" "App_PublicIP_rb" {
  name                = var.PublicIP_name[count.index]
  count=length(var.PublicIP_name)
  resource_group_name =data.azurerm_resource_group.cloud_in_azure_rb.name
  location            =data.azurerm_resource_group.cloud_in_azure_rb.location
  allocation_method   = "Static"

  tags = var.tags_PublicIP
  
}

#Creating Virtual machines
resource "azurerm_windows_virtual_machine" "AppVM_rb" {
  for_each = var.virtual_machine
  name=each.value
  resource_group_name = data.azurerm_resource_group.cloud_in_azure_rb.name
  location            = data.azurerm_resource_group.cloud_in_azure_rb.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
  azurerm_network_interface.App_NIC_rb[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

   connection {
    type     = "winrm"
    user     = "adminuser"
    password = "P@$$w0rd1234!"
    host     = self.public_ip_address
  }

  provisioner "remote-exec" {
    inline =[
      "powershell Install-WindowsFeature -name Web-Server -IncludeManagementTools",
      "powershell Add-Content -Path 'C:\\inetpub\\wwwroot\\index.html' -Value '<h1>Hello from IIS via remote-exec!</h1>'"
    ]
  }
  tags = {
    environment= "prod"
  }
lifecycle {
  prevent_destroy = true
}
}

# Creating Users

resource "azurerm_user_assigned_identity" "users_rb" {
  location            = data.azurerm_resource_group.cloud_in_azure_rb.location
  for_each = var.Users_Names
  name = each.value
  resource_group_name = data.azurerm_resource_group.cloud_in_azure_rb.name
}

#Network Security Group

resource "azurerm_network_security_group" "AppNSG_rb" {
  name                = "AppNSG"
  location            = data.azurerm_resource_group.cloud_in_azure_rb.location
  resource_group_name = data.azurerm_resource_group.cloud_in_azure_rb.name


dynamic "security_rule" {
    for_each = var.destination_port

  content{
    name                       = "InboundRule-${security_rule.value}"
    priority                   = 100 + index(var.destination_port, security_rule.value)
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = security_rule.value
    destination_address_prefix = "*"
    source_address_prefix      = "*"
  }
}

tags = var.tags_network_security_group
lifecycle {
  ignore_changes = [ tags ]
}

}

# azurerm_network_interface_security_group_association

resource "azurerm_network_interface_security_group_association" "example" {
  for_each = azurerm_network_interface.App_NIC_rb

  network_interface_id      = each.value.id
  network_security_group_id = azurerm_network_security_group.AppNSG_rb.id
}



# Managed Disk

resource "azurerm_managed_disk" "Datadisk_rb" {
  for_each = var.datadisk
  name = each.value
  location             = data.azurerm_resource_group.cloud_in_azure_rb.location
  resource_group_name  = data.azurerm_resource_group.cloud_in_azure_rb.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "10"
 
  tags = var.tags_managed_disk
}

