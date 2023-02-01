output "repository_url" {
  value       = module.ADO.repository_url
  description = "This is the URL that you would use to clone the repository. It is the same as the repository URL in the Azure DevOps UI."
}

output "postgres_endpoint" {
  value = module.az-container-apps.postgres_endpoint
}
output "sonarqube_endpoint" {
  value = module.az-container-apps.sonarqube_endpoint
}

output "temperature_endpoint" {
  value = module.az-container-apps.temperature_endpoint
}

