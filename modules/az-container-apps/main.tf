
terraform {
  required_providers {

    azapi = {
      source  = "azure/azapi"
      version = "1.2.0"
    }
  }
}


resource "azapi_resource" "env" {
  name      = "${var.az-container_env}-app"
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  location  = var.az_location
  parent_id = var.az_resource_group_id
  body = jsonencode({
    properties = {
      vnetConfiguration = {
        internal               = false
        infrastructureSubnetId = var.azurerm_subnet

      }
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = var.azurerm_log_analytics_workspace_id
          sharedKey  = var.azurerm_log_analytics_workspace_primary_shared_key
        }
      }
    }
  })
}

/*
resource "azapi_resource" "temperature_container_app" {
  name      = "temperature-container-app"
  location  = var.az_location
  parent_id = var.az_resource_group_id
  type      = "Microsoft.App/containerApps@2022-06-01-preview"
  body = jsonencode({
    properties = {
      managedEnvironmentId = azapi_resource.env.id
      configuration = {
        ingress = {
          targetPort    = 8080
          transport     = "Auto"
          external      = true
          allowInsecure = true
        },
        registries = [
          {
            server            = var.registry_host
            username          = var.registry_username
            passwordSecretRef = "registry-password"

          }
        ],
        secrets : [
          {
            name  = "registry-password"
            value = var.registry_password
          }
        ]
      },
      template = {
        containers = [
          {
            "image" : "docker.io/helloworld-http",
            "name" : "helloworld",
          }
        ]
        containers = [
          {
            image = "${var.registry_host}/${var.az_container_name}:latest"
            name  = "microservice-temp-app",
            env : [
              {
                "name" : "JBDC_URL",
                "value" : "${jsondecode(azapi_resource.postgres.output).properties.configuration.ingress.fqdn}:${jsondecode(azapi_resource.postgres.output).properties.configuration.ingress.exposedPort}"
              }
            ]
          }
        ]
        scale = {
          minReplicas = 2,
          maxReplicas = 3,
        }
      }
    }
  })
  # This seems to be important for the private registry to work(?)
  ignore_missing_property = true
  response_export_values  = ["properties.configuration.ingress"]
}

*/
resource "azapi_resource" "postgres" {
  name      = "postgres-container-app"
  location  = var.az_location
  parent_id = var.az_resource_group_id
  type      = "Microsoft.App/containerApps@2022-06-01-preview"
  body = jsonencode({
    properties = {
      managedEnvironmentId = azapi_resource.env.id
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
            "image" : "docker.io/postgres:12",
            "name" : "postgres12",
            "env" : [
              {
                "name" : "POSTGRES_PASSWORD",
                "value" : "mysecretpassword"
              }
            ]
          }
        ]
        scale = {
          minReplicas = 2,
          maxReplicas = 5,
        }
      }
    }
  })
  ignore_missing_property = true
  response_export_values  = ["properties.configuration.ingress"]
}

resource "azapi_resource" "sonarqube" {
  name      = "sonarqube-container-app"
  location  = var.az_location
  parent_id = var.az_resource_group_id
  type      = "Microsoft.App/containerApps@2022-06-01-preview"
  body = jsonencode({
    properties = {
      managedEnvironmentId = azapi_resource.env.id
      configuration = {
        ingress = {
          targetPort    = 9000
          transport     = "Auto"
          external      = true
          allowInsecure = true
        }
      },
      template = {
        containers = [
          {
            "image" : "docker.io/sonarqube:latest",
            "name" : "sonarqube",
            resources : {
              "cpu" : 2,
              "memory" : "4Gi"
            }
          }
        ]
      }

    }
  })
  ignore_missing_property = true
  response_export_values  = ["properties.configuration.ingress"]
}

