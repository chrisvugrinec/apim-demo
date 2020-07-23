resource "azurerm_resource_group" "network-rg" {
  name     = var.mgmt-rg
  location = var.location
}

resource "azurerm_virtual_network" "mgmt-vnet" {
  name                = var.mgmt-vnet
  address_space       = [var.mgmt-vnet-cidr]
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  tags = var.tags
}

resource "azurerm_virtual_network" "aks-vnet" {
  name                = var.aks-vnet
  address_space       = [var.aks-vnet-cidr]
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  tags = var.tags
}

resource "azurerm_subnet" "mgmt-subnet" {
  name                 = var.mgmt-subnet
  resource_group_name  = azurerm_resource_group.network-rg.name
  virtual_network_name = azurerm_virtual_network.mgmt-vnet.name
  address_prefixes       = [var.mgmt-subnet-cidr]
}

resource "azurerm_subnet" "apim-subnet" {
  name                 = var.apim-subnet
  resource_group_name  = azurerm_resource_group.network-rg.name
  virtual_network_name = azurerm_virtual_network.mgmt-vnet.name
  address_prefixes       = [var.apim-subnet-cidr]
}

data "azurerm_virtual_network" "mgmt-vnet" {
  name                = var.mgmt-vnet
  resource_group_name = azurerm_resource_group.network-rg.name
  depends_on          = [azurerm_virtual_network.mgmt-vnet]
}

data "azurerm_virtual_network" "aks-vnet" {
  name                = var.aks-vnet
  resource_group_name = azurerm_resource_group.network-rg.name
  depends_on          = [azurerm_virtual_network.aks-vnet]
}


# MgmtHub VNET Peering to AKS
resource "azurerm_virtual_network_peering" "mgmt-aks-peering" {
  name                         = "${var.mgmt-vnet}-to-${var.aks-vnet}"
  resource_group_name          = azurerm_resource_group.network-rg.name
  virtual_network_name         = azurerm_virtual_network.mgmt-vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.aks-vnet.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

# AKS VNET Peering to ManagementHub
resource "azurerm_virtual_network_peering" "aks-mgmt-peering" {
  name                         = "${var.aks-vnet}-to-${var.mgmt-vnet}"
  resource_group_name          = azurerm_resource_group.network-rg.name
  virtual_network_name         = azurerm_virtual_network.aks-vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.mgmt-vnet.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

output apim-subnet-id {
   value =  azurerm_subnet.apim-subnet.id
}
