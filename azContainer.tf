resource "azurerm_resource_group" "this" {
  name     = local.az_resource_group_name
  location = var.az_location
}

resource "azurerm_container_registry" "acr" {
  name                = local.az_container_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "Basic"
  admin_enabled       = true
}
