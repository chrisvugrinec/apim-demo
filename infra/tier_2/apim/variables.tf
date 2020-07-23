variable "tags" {
  type = map
  default = {
    environment = "demo"
    source      = "microsoft"
  }
}

variable "apim-name" {}
variable "apim-subnet-id" {}
variable "location" {}
variable "mgmt-rg" {}
variable "publisher" {
  default = "Microsoft CSU"
}
variable "publisher-email" {
  default = "contoso@microsoft.com"
}
