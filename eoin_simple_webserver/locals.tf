locals {
  custom_data = <<CUSTOM_DATA
  #cloud-config
  runcmd:
    - sudo apt install -y apache2
  CUSTOM_DATA
}