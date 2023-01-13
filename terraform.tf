provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=1.32.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.6.0"
    }
  }
}


