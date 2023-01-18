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