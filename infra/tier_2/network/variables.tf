variable "tags" {
  type = map
  default = {
    environment = "demo"
    source      = "microsoft"
  }
}

variable "mgmt-rg" {}
variable "location" {}

variable "aks-vnet" {
  default = "vuggie-aks-demo-vnet"
}

variable "aks-vnet-cidr" {
  default = "15.1.0.0/16"
}

variable "mgmt-vnet" {
  default = "vuggie-mgmt-demo-vnet"
}

variable "mgmt-subnet" {
  default = "vuggie-mgmt-demo-subnet"
}

variable "mgmt-vnet-cidr" {
  default = "10.1.0.0/16"
}

variable "mgmt-subnet-cidr" {
  default = "10.1.1.0/24"
}

variable "apim-subnet" {
  default = "vuggie-apim-demo-subnet"
}

variable "apim-subnet-cidr" {
  default = "10.1.100.0/24"
}

