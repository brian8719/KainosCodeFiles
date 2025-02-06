resource "azurerm_resource_group" "new_rg" {
  name     = "${var.task_number}-rg-eoin"
  location = var.azure_region
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = "${var.task_number}-vm-eoin"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.new_rg.name
  size                = var.vm_size
  admin_username      = var.admin_id
  zone                = var.av_zone

  os_disk {
    storage_account_type = var.os_disk_type
    caching              = "ReadWrite"
  }

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "24.04.202501090"
  }

  admin_ssh_key {
    username   = var.admin_id
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  custom_data = base64encode(local.custom_data)
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "priv_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "terraformlinuxkey.pem"
}

resource "azurerm_managed_disk" "data_disk" {
  name                 = "${var.task_number}-datadisk1-eoin"
  location             = var.azure_region
  resource_group_name  = azurerm_resource_group.new_rg.name
  storage_account_type = var.data_disk_type
  create_option        = "Empty"
  disk_size_gb         = "4"
  zone                 = var.av_zone
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attach" {
  managed_disk_id    = azurerm_managed_disk.data_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.linux_vm.id
  lun                = 1
  caching            = "ReadWrite"
}
