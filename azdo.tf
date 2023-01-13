
provider "azuredevops" {
  org_service_url = var.ado_org_service_url

}

resource "azuredevops_project" "this" {
  name       = "Project"
  visibility = "private"
}


resource "azuredevops_git_repository" "example" {
  project_id     = azuredevops_project.this.id
  name           = "testRepo"
  default_branch = "refs/heads/master"
  initialization {
    init_type = "Clean"
  }
}

resource "azuredevops_git_repository_file" "main" {
  repository_id       = azuredevops_git_repository.example.id
  file                = "azure-pipeline-main.yml"
  content             = file("azure-pipeline-main.yml")
  branch              = "refs/heads/master"
  commit_message      = "First commit"
  overwrite_on_create = false
}


resource "azuredevops_build_definition" "pipeline_1" {

  project_id = azuredevops_project.this.id
  name       = "Master"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.example.id
    branch_name = azuredevops_git_repository.example.default_branch
    yml_path    = "azure-pipeline-main.yml"
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
    name = "repository_name"
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
}

resource "azuredevops_resource_authorization" "kv_auth" {
  project_id  = azuredevops_project.this.id
  resource_id = azuredevops_serviceendpoint_dockerregistry.container_registry.id
  authorized  = true
}
