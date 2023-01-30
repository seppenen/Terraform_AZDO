resource "azapi_resource" "aca-test-environment" {
  name      = local.az-container_app_name
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  location  = var.az_location
  parent_id = azurerm_resource_group.this.id
  body = jsonencode({
    properties = {
      vnetConfiguration = {
        internal               = false
        infrastructureSubnetId = azurerm_subnet.subnet.id

      }
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.env.workspace_id
          sharedKey  = azurerm_log_analytics_workspace.env.primary_shared_key
        }
      }
    }
  })
}

resource "azapi_resource" "aca-test-environment2" {
  name      = "testenvAz"
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  location  = var.az_location
  parent_id = azurerm_resource_group.this.id
  body = jsonencode({
    properties = {
      vnetConfiguration = {
        internal               = false
        infrastructureSubnetId = azurerm_subnet.subnet.id

      }
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.env.workspace_id
          sharedKey  = azurerm_log_analytics_workspace.env.primary_shared_key
        }
      }
    }
  })
}

resource "azapi_resource" "temperature_container_app" {
  name      = "temperature-container-app"
  location  = var.az_location
  parent_id = azurerm_resource_group.this.id
  type      = "Microsoft.App/containerApps@2022-06-01-preview"
  body = jsonencode({
    properties = {
      managedEnvironmentId = azapi_resource.aca-test-environment.id
      configuration = {
        ingress = {
          targetPort    = 8080
          transport     = "Auto"
          external      = true
          allowInsecure = true
        },
        registries = [
          {
            server            = azurerm_container_registry.acr.login_server
            username          = azurerm_container_registry.acr.admin_username
            passwordSecretRef = "registry-password"

          }
        ],
        secrets : [
          {
            name = "registry-password"
            # Todo: Container apps does not yet support Managed Identity connection to ACR
            value = azurerm_container_registry.acr.admin_password
          }
        ]
      },
      template = {
      containers = [
         {
           image = "${azurerm_container_registry.acr.login_server}/${local.az_container_name}:latest"
           name  = "microservice-temp-app",
           env : [
             {
               "name" : "EnvVariable",
               "value" : "Value"
             }
           ]
         }
       ]
      }
    }
  })
  # This seems to be important for the private registry to work(?)
  ignore_missing_property = true
  response_export_values  = ["properties.configuration.ingress"]
}

resource "azapi_resource" "postgres" {
  name      = "postgres-container-app"
  location  = var.az_location
  parent_id = azurerm_resource_group.this.id
  type      = "Microsoft.App/containerApps@2022-06-01-preview"
  body = jsonencode({
    properties = {
      managedEnvironmentId = azapi_resource.aca-test-environment2.id
      configuration = {
        ingress = {
          targetPort  = 5432
          exposedPort = 5432
          transport   = "tcp"
          external    = true
        }
      },
      template = {
        containers = [
          {
            "image" : "docker.io/postgres:13",
            "name" : "postgres13",
            "env" : [
              {
                "name" : "POSTGRES_PASSWORD",
                "value" : "mysecretpassword"
              }
            ]
          }
        ]
      }
    }
  })
  # This seems to be important for the private registry to work(?)
  ignore_missing_property = true
  response_export_values  = ["properties.configuration.ingress"]
}

resource "azapi_resource" "sonarqube" {
  name      = "sonarqube-container-app"
  location  = var.az_location
  parent_id = azurerm_resource_group.this.id
  type      = "Microsoft.App/containerApps@2022-06-01-preview"
  body = jsonencode({
    properties = {
      managedEnvironmentId = azapi_resource.aca-test-environment2.id
      configuration = {
        ingress = {
          targetPort  = 9000
          exposedPort = 9000
          transport   = "tcp"
          external    = true
        }
      },
      template = {
        containers = [
          {
            "image" : "docker.io/sonarqube",
            "name" : "sonarqube",
            resources: {
              "cpu": 2,
              "memory": "4.0Gi"
            }
          }
        ]
      }

    }
  })

  ignore_missing_property = true
  response_export_values  = ["properties.configuration.ingress"]
}

data "azapi_resource" "postgres" {
  name                   = "postgres-container-app"
  parent_id              = azurerm_resource_group.this.id
  type                   = "Microsoft.App/containerApps@2022-06-01-preview"
  response_export_values = ["properties.latestRevisionFqdn", "properties.policies.quarantinePolicy.status"]
}

#Print out postgres fqdn
output "postgresRevisionFqdn" {
  value = jsondecode(data.azapi_resource.postgres.output).properties.latestRevisionFqdn
}
