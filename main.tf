# Create a resource group for network
resource "azurerm_resource_group" "network-rg" {
  name = "network-rg"
  location = var.location
}
# Create the network VNET
resource "azurerm_virtual_network" "network-vnet" {
  name = "network-vnet"
  address_space = [var.network-vnet-cidr]
  resource_group_name = azurerm_resource_group.network-rg.name
  location = azurerm_resource_group.network-rg.location
}
# Create a subnet for VM
resource "azurerm_subnet" "vm-subnet" {
  name = "vm-subnet"
  address_prefixes = [var.network-subnet-cidr]
  virtual_network_name = azurerm_virtual_network.network-vnet.name
  resource_group_name  = azurerm_resource_group.network-rg.name
}

# Generate random password
resource "random_password" "linux-vm-password" {
  length           = 16
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  number           = true
  special          = true
  override_special = "!@#$%&"
}
# Generate a random vm name
resource "random_string" "linux-vm-name" {
  length  = 8
  upper   = false
  number  = false
  lower   = true
  special = false
}
# Create Security Group to access linux
resource "azurerm_network_security_group" "linux-vm-nsg" {
  depends_on=[azurerm_resource_group.network-rg]
  name                = "linux-vm-nsg"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  security_rule {
    name                       = "AllowHTTP"
    description                = "Allow HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowSSH"
    description                = "Allow SSH"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}
# Associate the linux NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "linux-vm-nsg-association" {
  depends_on=[azurerm_resource_group.network-rg]
  subnet_id                 = azurerm_subnet.vm-subnet.id
  network_security_group_id = azurerm_network_security_group.linux-vm-nsg.id
}
# Get a Static Public IP
resource "azurerm_public_ip" "linux-vm-ip" {
  depends_on=[azurerm_resource_group.network-rg]
  name                = "linux-vm-ip"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  allocation_method   = "Static"
}
# Create Network Card for linux VM
resource "azurerm_network_interface" "linux-vm-nic" {
  depends_on=[azurerm_resource_group.network-rg]
  name                = "linux-vm-nic"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux-vm-ip.id
  }
}
# Create Linux VM with linux server
resource "azurerm_linux_virtual_machine" "linux-vm" {
  depends_on=[azurerm_network_interface.linux-vm-nic]
  location              = azurerm_resource_group.network-rg.location
  resource_group_name   = azurerm_resource_group.network-rg.name
  name                  = "linux-vm"
  network_interface_ids = [azurerm_network_interface.linux-vm-nic.id]
  size                  = var.linux_vm_size
  source_image_reference {
    offer     = var.linux_vm_image_offer
    publisher = var.linux_vm_image_publisher
    sku       = var.rhel_8_5_sku
    version   = "latest"
  }
  os_disk {
    name                 = "linux-vm-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  computer_name  = "linux-vm"
  admin_username = var.linux_admin_username
  admin_password = random_password.linux-vm-password.result
  custom_data    = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  disable_password_authentication = false
}
# Template for bootstrapping
data "template_file" "linux-vm-cloud-init" {
  template = file("azure-user-data.sh")
}