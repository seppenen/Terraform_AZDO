provider "azuredevops" {
  org_service_url       = var.ado_org_service_url
  personal_access_token = var.ado_personal_access_token
}
terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.3.0"
    }
  }
}


resource "azuredevops_project" "this" {
  name               = var.ado_project_name
  visibility         = var.ado_project_visibility
  work_item_template = "Agile"
}

resource "azuredevops_git_repository" "repo" {
  project_id = azuredevops_project.this.id
  name       = var.ado_repository_name
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
  service_endpoint_name = var.az_lib_service_endpoint_name
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
  name         = "container-registry-data"
  description  = "Variable group for pipelines"
  allow_access = true

  variable {
    name  = "service_endpoint_name"
    value = var.az_container_service_endpoint_name
  }

  variable {
    name  = "repository_name"
    value = var.az_container_name
  }

  variable {
    name  = "postgresRevisionFqdn"
    value = var.postgres_endpoint
  }
}

resource "azuredevops_serviceendpoint_dockerregistry" "container_registry" {
  project_id            = azuredevops_project.this.id
  service_endpoint_name = var.az_container_service_endpoint_name
  docker_registry       = var.registry_host
  docker_username       = var.registry_username
  docker_password       = var.registry_password
  registry_type         = "Others"
  description           = "This service endpoint is used to access the container registry"
}

resource "azuredevops_resource_authorization" "kv_auth" {
  project_id  = azuredevops_project.this.id
  resource_id = azuredevops_serviceendpoint_dockerregistry.container_registry.id
  authorized  = true
}


