resource "azurerm_api_management" "demo" {
  name                = var.apim-name
  location            = var.location
  resource_group_name = var.mgmt-rg
  publisher_name      = var.publisher
  publisher_email     = var.publisher-email
  tags                = var.tags

  virtual_network_type = "Internal"
 
  virtual_network_configuration {
    subnet_id = var.apim-subnet-id
  }

  sku_name = "Developer_1"

  policy {
    xml_content = <<XML
    <policies>
      <inbound />
      <backend />
      <outbound />
      <on-error />
    </policies>
XML

  }
}
