output "repository_url" {
  value       = azuredevops_git_repository.repo.remote_url
  description = "This is the URL that you would use to clone the repository. It is the same as the repository URL in the Azure DevOps UI."
}