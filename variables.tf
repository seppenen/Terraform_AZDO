variable "ado_org_service_url" {
  type        = string
  description = "Org service url for Azure DevOps"
  default     = "https://dev.azure.com/aleksandrseppenen"
}

variable "ado_pipeline_yaml_path_1" {
  type        = string
  description = "Path to the yaml for the first pipeline"
  default     = "azure-pipeline-main.yml"
}

variable "ado_repo_username" {
  type        = string
  description = "Username for the repo"
  default     = "aleksandr.seppenen"
}

variable "ado_repo_password" {
  type        = string
  description = "Name of the repository in the format <GitHub Org>/<RepoName>"
}

variable "ado_personal_access_token" {
  type        = string
  description = "Personal access token for Azure DevOps"
}

variable "prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "terraform"
}

variable "az_location" {
  type    = string
  default = "Sweden central"
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}


variable "kubernetes_version" {
  default = "1.16.10"
}

variable "ssh_key" {
  default = "~/.ssh/id_rsa.pub"
}


locals {
  ado_project_name              = "${var.prefix}-project-${random_integer.suffix.result}"
  ado_repository_name           = "${var.prefix}-pipeline-${random_integer.suffix.result}"
  ado_project_description       = "Project for ${var.prefix}"
  ado_project_visibility        = "private"
  az_container_name             = "${var.prefix}Container${random_integer.suffix.result}"
  az_cluster_name               = "${var.prefix}-Cluster-${random_integer.suffix.result}"
  az_container_service_endpoint = "AZ Container Registry"
  az_lib_service_endpoint       = "Ext-lib-0928"
  az_resource_group_name        = "${var.prefix}-${random_integer.suffix.result}"
  host                          = azurerm_kubernetes_cluster.this.kube_config.0.host
  client_key                    = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.client_key)
  client_certificate            = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.client_certificate)
  cluster_ca_certificate        = base64decode(azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
  kube_config                   = azurerm_kubernetes_cluster.this.kube_config_raw
}
