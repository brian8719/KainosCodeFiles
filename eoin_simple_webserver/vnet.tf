resource "azurerm_virtual_network" "vm_vnet" {
  name                = "${var.task_number}-vnet-eoin"
  address_space       = ["10.0.0.0/16"]
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.new_rg.name
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = "${var.task_number}-subnet-eoin"
  address_prefixes     = ["10.0.0.0/24"]
  virtual_network_name = azurerm_virtual_network.vm_vnet.name
  resource_group_name  = azurerm_resource_group.new_rg.name
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.task_number}-nic-eoin"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.new_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.task_number}-nsg-eoin"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.new_rg.name
}

resource "azurerm_network_security_rule" "vm_nsg_rule" {
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
  resource_group_name         = azurerm_resource_group.new_rg.name
  name                        = "AllowSSH"
  description                 = "Allow SSH inbound"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "vm_nsg_http_rule" {
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
  resource_group_name         = azurerm_resource_group.new_rg.name
  name                        = "AllowHTTP"
  description                 = "Allow HTTP inbound"
  priority                    = 310
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

resource "azurerm_public_ip" "vm_pip" {
  name                = "${var.task_number}-pip-eoin"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.new_rg.name
  allocation_method   = "Static"
}