output "registry_host" {
  value = azurerm_container_registry.acr.login_server
  description = "The login server of the container registry"
}


output "registry_username" {
  value = azurerm_container_registry.acr.admin_username
    description = "The admin username of the container registry"
}


output "registry_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
    description = "The admin password of the container registry"
}

output "azurerm_resource_group_id" {
    value = azurerm_resource_group.this.id
    description = "The name of the resource group"
}

output "azurerm_subnet" {
    value = azurerm_subnet.subnet.id
    description = "The name of the subnet"

}

output "azurerm_log_analytics_workspace_id" {
    value = azurerm_log_analytics_workspace.log.workspace_id
    description = "The name of the log analytics workspace"
}

output "azurerm_log_analytics_workspace_primary_shared_key" {
  value = azurerm_log_analytics_workspace.log.primary_shared_key
    description = "The primary shared key of the log analytics workspace"
}