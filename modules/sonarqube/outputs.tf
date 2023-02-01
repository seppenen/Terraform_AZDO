output "user_token" {
  value     = sonarqube_user_token.token.token
  sensitive = true
}