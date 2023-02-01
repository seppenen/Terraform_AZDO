
variable "az_location" {
  type    = string
  description = "Azure region to deploy resources"
}


variable "azurerm_log_analytics_workspace_id" {
  type    = string
  description = "Log Analytics Workspace"
}

variable "azurerm_log_analytics_workspace_primary_shared_key" {
    type    = string
    description = "Log Analytics Workspace Primary Key"
}

variable "az_resource_group_id" {
    type    = string
    description = "Resource group ID"
}
variable "az_container_name" {
  type    = string
  description = "Azure Container name"
}

variable "az-container_env" {
    type    = string
    description = "Azure Container App environment"
}

variable "azurerm_subnet" {
    type    = string
    description = "Azure Subnet name"
}

variable "registry_password" {
  type        = string
  description = "Password for the docker registry"
}
variable "registry_host" {
  type        = string
  description = "Name of the docker registry"
}

variable "registry_username" {
  type        = string
  description = "Username for the docker registry"
}