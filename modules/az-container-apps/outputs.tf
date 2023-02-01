
output "postgres_endpoint" {
  value = jsondecode(azapi_resource.postgres.output).properties.configuration.ingress.fqdn
}
output "sonarqube_endpoint" {
  value = jsondecode(azapi_resource.sonarqube.output).properties.configuration.ingress.fqdn
}

output "temperature_endpoint" {
  value = jsondecode(azapi_resource.temperature_container_app.output).properties.configuration.ingress.fqdn
}