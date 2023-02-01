
module "ADO" {
  source                             = "./modules/ADO"
  postgres_endpoint                  = module.az-container-apps.postgres_endpoint
  registry_host                      = module.az-environment.registry_host
  registry_username                  = module.az-environment.registry_username
  registry_password                  = module.az-environment.registry_password
  ado_project_name                   = local.ado_project_name
  az_container_name                  = local.az_container_name
  ado_repository_name                = local.ado_repository_name
  az_container_service_endpoint_name = local.az_container_service_endpoint_name
  az_lib_service_endpoint_name       = local.az_lib_service_endpoint_name
  ado_repo_password                  = var.ado_repo_password
  ado_personal_access_token          = var.ado_personal_access_token

}

module "az-container-apps" {
  source                                             = "./modules/az-container-apps"
  az_location                                        = var.az_location
  az-container_env                                   = local.az_container_app_env
  az_resource_group_id                               = module.az-environment.azurerm_resource_group_id
  azurerm_subnet                                     = module.az-environment.azurerm_subnet
  az_container_name                                  = local.az_container_name
  azurerm_log_analytics_workspace_id                 = module.az-environment.azurerm_log_analytics_workspace_id
  azurerm_log_analytics_workspace_primary_shared_key = module.az-environment.azurerm_log_analytics_workspace_primary_shared_key
  registry_host                                      = module.az-environment.registry_host
  registry_username                                  = module.az-environment.registry_username
  registry_password                                  = module.az-environment.registry_password
}

module "az-environment" {
  source                 = "./modules/az-environment"
  az_location            = var.az_location
  az_resource_group_name = local.az_resource_group_name
  az_log_analytics_name  = local.az_log_analytics_name
  az_vnet_name           = local.az_vnet_name
  az_subnet_name         = local.az_subnet_name
  az_container_name      = local.az_container_name
}