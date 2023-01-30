provider "azurerm" {
  features {}
}

provider "azapi" {
}

terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.41.0"
    }
    sonarqube = {
      source = "jdamata/sonarqube"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.6.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.17.0"
    }
  }
}

