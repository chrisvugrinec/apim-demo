variable "tags" {
  type = map
  default = {
    environment = "demo"
    source      = "microsoft"
  }
}

variable "environment" {
  default = "dev"
}

variable "tier" {
  default = "3"
}

variable "mgmt-tier" {
  default = "2"
}

variable "resourcetype" {
  default = "aks"
}

variable "location" {
  default = "australiaeast"
}

variable "aks-vnet" {
  default = "vuggie-aks-demo-vnet"
}
