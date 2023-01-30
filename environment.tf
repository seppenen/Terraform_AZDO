resource "azurerm_resource_group" "this" {
  name     = local.az_resource_group_name
  location = var.az_location
}

resource "azurerm_log_analytics_workspace" "env" {
  name                = local.az_log_analytics_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_virtual_network" "network" {
  name                = local.az_vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = "northeurope"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "subnet" {
  name                 = local.az_subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.0.0/23"]

}

resource "azurerm_container_registry" "acr" {
  name                = local.az_container_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Print container registry login server
output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

#Print container registry admin username
output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

#Print container registry admin password
output "acr_admin_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}