variable "prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "terraform"
}

variable "ado_personal_access_token" {
  type        = string
  description = "Personal access token for Azure DevOps"
}

variable "ado_org_service_url" {
  type        = string
  description = "Org service url for Azure DevOps"
  default     = "https://dev.azure.com/aleksandrseppenen"
}

variable "ado_repo_password" {
  type        = string
  description = "Name of the repository in the format <GitHub Org>/<RepoName>"
}

variable "az_location" {
  type    = string
  default = "northeurope"
}
resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

locals {
  ado_project_name                   = "${var.prefix}-project-${random_integer.suffix.result}"
  ado_repository_name                = "${var.prefix}-pipeline-${random_integer.suffix.result}"
  ado_project_description            = "Project for ${var.prefix}"
  az_container_name                  = "${var.prefix}container${random_integer.suffix.result}"
  az_container_app_env               = "${var.prefix}-env-${random_integer.suffix.result}"
  az_log_analytics_name              = "${var.prefix}-log-analytics-${random_integer.suffix.result}"
  az_vnet_name                       = "${var.prefix}-vnet-${random_integer.suffix.result}"
  az_subnet_name                     = "${var.prefix}-subnet-${random_integer.suffix.result}"
  az_container_service_endpoint_name = "AZ Container Registry"
  az_lib_service_endpoint_name       = "Ext-lib-0928"
  az_resource_group_name             = "${var.prefix}-${random_integer.suffix.result}"
}
