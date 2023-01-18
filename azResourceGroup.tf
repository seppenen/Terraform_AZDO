resource "azurerm_resource_group" "this" {
  name     = local.az_resource_group_name
  location = var.az_location
}

