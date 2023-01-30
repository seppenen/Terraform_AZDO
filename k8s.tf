
provider "kubernetes" {
  host                   = local.host
  client_certificate     = local.client_certificate
  client_key             = local.client_key
  cluster_ca_certificate = local.cluster_ca_certificate
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "sonarqube"
    labels = {
      test = "MyExampleApp"
    }
  }

  spec {

    selector {
      match_labels = {
        test = "sonarqube"
      }
    }

    template {
      metadata {
        labels = {
          test = "sonarqube"
        }
      }

      spec {
        container {
          image = "docker.io/sonarqube"
          name  = "sonarqube"

          resources {
            limits = {
              cpu    = "1"
              memory = "4Gi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
          port {
            container_port = 9000
            protocol = "TCP"
          }

          env {
            name  = "SONAR_JDBC_USERNAME"
            value = "postgres"
          }
          env {
            name  = "SONAR_JDBC_PASSWORD"
            value = "mysecretpassword"
          }
          env {
            name  = "SONAR_JDBC_URL"
            value = "jdbc:postgresql://${jsondecode(data.azapi_resource.postgres.output).properties.latestRevisionFqdn}:5432/postgres"
          }
        }

      }
    }
  }
}


resource "kubernetes_service" "example" {
  metadata {
    name = "sonarqube"
  }
  spec {
    selector = {
      test = "sonarqube"
    }
    port {
      name = "port9000"
      port        = 80
      target_port = 9000
    }
    type = "LoadBalancer"
  }
}