variable "tags" {
  type = map
  default = {
    environment = "demo"
    source      = "microsoft"
  }
}

variable "admin_group_object_id" {
  default = "b79f3bde-c504-49f0-9ed9-8a8cf92ee644"
}

variable "k8-version" {
  default = "1.18.4"
}

variable "id-name" {}
variable "dns-zone" {}
variable "keyvault-name" {}
variable "aks-name" {}
variable "rg-name" {}
variable "location" {}

variable "aks-vnet" {}
variable "mgmt-vnet" {}
variable "mgmt-rg" {}
variable "aks-subnet-cidr" {}
