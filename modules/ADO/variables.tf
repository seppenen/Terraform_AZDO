

variable "ado_project_visibility" {
    type    = string
    default = "private"
}

variable "ado_org_service_url" {
  type        = string
  description = "Org service url for Azure DevOps"
  default     = "https://dev.azure.com/aleksandrseppenen"
}
variable "ado_personal_access_token" {
  type        = string
  description = "Personal access token for Azure DevOps"
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

variable "az_lib_service_endpoint_name" {
  type        = string
  description = "Name of the service endpoint for the library"
}

variable "ado_project_name" {
    type        = string
    description = "Name of the project in Azure DevOps"
}

variable "az_container_name" {
    type        = string
    description = "Name of the container in Azure Storage"
}

variable "ado_repository_name" {
    type        = string
    description = "Name of the repository in Azure DevOps"
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

variable "postgres_endpoint" {
    type        = string
    description = "Endpoint for the postgres database"
}

variable "az_container_service_endpoint_name" {
    type        = string
    description = "Name of the service endpoint for the container registry"
}