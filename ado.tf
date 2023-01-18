provider "azuredevops" {
  org_service_url       = var.ado_org_service_url
  personal_access_token = var.ado_personal_access_token
}

resource "azuredevops_project" "this" {
  name               = local.ado_project_name
  visibility         = local.ado_project_visibility
  work_item_template = "Agile"
}

resource "azuredevops_git_repository" "repo" {
  project_id = azuredevops_project.this.id
  name       = local.ado_repository_name
  initialization {
    init_type             = "Import"
    source_type           = "Git"
    source_url            = "https://ext-lib-0928@dev.azure.com/ext-lib-0928/ext-lib-0928/_git/ext-lib-0928"
    service_connection_id = azuredevops_serviceendpoint_generic_git.service_endpoint.id
  }
}

resource "azuredevops_serviceendpoint_generic_git" "service_endpoint" {
  project_id            = azuredevops_project.this.id
  repository_url        = "https://ext-lib-0928@dev.azure.com/ext-lib-0928/ext-lib-0928/_git/ext-lib-0928"
  username              = var.ado_repo_username
  password              = var.ado_repo_password
  service_endpoint_name = local.az_lib_service_endpoint
  description           = "This service endpoint is used to access the repository library"
}

resource "azuredevops_build_definition" "master" {
  project_id = azuredevops_project.this.id
  name       = "Master"
  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.repo.id
    branch_name = "master"
    yml_path    = "azure-pipeline-main.yml"
  }
}

resource "azuredevops_build_definition" "feature" {
  project_id = azuredevops_project.this.id
  name       = "Feature"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.repo.id
    branch_name = "feature"
    yml_path    = "azure-pipeline-feature.yml"
  }
}

resource "azuredevops_variable_group" "variable-group" {
  project_id   = azuredevops_project.this.id
  name         = "container-registry-access-data"
  description  = "Variable group for pipelines"
  allow_access = true

  variable {
    name  = "service_endpoint_name"
    value = local.az_container_service_endpoint
  }

  variable {
    name  = "repository_name"
    value = azurerm_container_registry.acr.name
  }
}

resource "azuredevops_serviceendpoint_dockerregistry" "container_registry" {
  project_id            = azuredevops_project.this.id
  service_endpoint_name = local.az_container_service_endpoint
  docker_registry       = azurerm_container_registry.acr.login_server
  docker_username       = azurerm_container_registry.acr.admin_username
  docker_password       = azurerm_container_registry.acr.admin_password
  registry_type         = "Others"
  description           = "This service endpoint is used to access the container registry"
}

resource "azuredevops_resource_authorization" "kv_auth" {
  project_id  = azuredevops_project.this.id
  resource_id = azuredevops_serviceendpoint_dockerregistry.container_registry.id
  authorized  = true
}

output "repository_url" {
  value       = azuredevops_git_repository.repo.remote_url
  description = "This is the URL that you would use to clone the repository. It is the same as the repository URL in the Azure DevOps UI."
}
