variable "azure_region" {
  type    = string
  default = "US East"
}

variable "task_number" {
  type    = string
  default = "task2"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1ms"
}

variable "os_disk_type" {
  type    = string
  default = "StandardSSD_LRS"
}

variable "data_disk_type" {
  type = string
}

variable "admin_id" {
  type = string
}

variable "av_zone" {
  type = number
}