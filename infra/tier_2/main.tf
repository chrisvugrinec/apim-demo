provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name   = "chris-ms-data"
    storage_account_name  = "vuggietfstate"
    container_name        = "tstate-apimdemo-tier2"
    key                   = "terraform.tfstate"
  }
}

locals {
  name-convention = "${var.environment}-${var.location}-${var.tier}"
}

# This is a shared Component
module "network" {
  source        = "./network"
  mgmt-rg       = "${local.name-convention}-apimdemo-mgmt-resources"
  location      = var.location
}

module "apim" {
  source        = "./apim"
  mgmt-rg       = "${local.name-convention}-apimdemo-mgmt-resources"
  location      = var.location
  apim-name     = "vuggie-apim-demo1"
  apim-subnet-id = module.network.apim-subnet-id
}
