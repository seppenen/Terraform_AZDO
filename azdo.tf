
provider "azuredevops" {
  org_service_url       = var.ado_org_service_url
  personal_access_token = var.ado_personal_access_token

}

resource "azuredevops_project" "this" {
  name               = "Project"
  visibility         = "private"
  work_item_template = "Agile"
}

resource "azuredevops_serviceendpoint_generic_git" "serviceendpoint" {
  project_id            = azuredevops_project.this.id
  repository_url        = "https://yamls@dev.azure.com/yamls/test/_git/test"
  username              = var.ado_repo_username
  password              = var.ado_repo_password
  service_endpoint_name = "Repository library"
  description           = "This service endpoint is used to access the repository library"
}

resource "azuredevops_git_repository" "example" {
  project_id     = azuredevops_project.this.id
  name           = "testRepo"
  default_branch = "refs/heads/Master"
  initialization {
    init_type             = "Import"
    source_type           = "Git"
    source_url            = "https://yamls@dev.azure.com/yamls/test/_git/test"
    service_connection_id = azuredevops_serviceendpoint_generic_git.serviceendpoint.id
  }
}

resource "azuredevops_build_definition" "master" {

  project_id = azuredevops_project.this.id
  name       = "Master"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.example.id
    branch_name = "Master"
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
    repo_id     = azuredevops_git_repository.example.id
    branch_name = "Feature"
    yml_path    = "azure-pipeline-feature.yml"
  }
}

resource "azuredevops_variable_group" "variable-group" {
  project_id   = azuredevops_project.this.id
  name         = "container-registry"
  description  = "Variable group for pipelines"
  allow_access = true

  variable {
    name  = "service_connection_name"
    value = local.az_service_endpoint_name
  }

  variable {
    name  = "repository_name"
    value = azurerm_container_registry.acr.name
  }

}

resource "azuredevops_serviceendpoint_dockerregistry" "container_registry" {
  project_id            = azuredevops_project.this.id
  service_endpoint_name = local.az_service_endpoint_name
  docker_registry       = azurerm_container_registry.acr.login_server
  docker_username       = azurerm_container_registry.acr.admin_username
  docker_password       = azurerm_container_registry.acr.admin_password
  registry_type         = "Others"
  description = "This service endpoint is used to access the container registry"
}

resource "azuredevops_resource_authorization" "kv_auth" {
  project_id  = azuredevops_project.this.id
  resource_id = azuredevops_serviceendpoint_dockerregistry.container_registry.id
  authorized  = true
}
