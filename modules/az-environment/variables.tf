

variable "az_location" {
  type    = string
  description = "Azure region to deploy resources"
}

variable "az_resource_group_name" {
  type    = string
  description = "Resource group name"
}

variable "az_log_analytics_name" {
    type    = string
    description = "Log Analytics workspace name"
}

variable "az_vnet_name" {
    type    = string
    description = "Virtual Network name"
}

variable "az_subnet_name" {
    type    = string
    description = "Subnet name"
}

variable "az_container_name" {
    type    = string
    description = "Azure Container name"
}


