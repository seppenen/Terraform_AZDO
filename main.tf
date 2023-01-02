terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm",
      version = "=3.37.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "33b3b224-9283-4912-b5c4-2b486c357a88"
  tenant_id       = "db43938a-0cfa-4793-9bf8-a2e7a62143a6"
  client_id       = "f1f5dad4-b2c7-4a9e-a4b6-93dbe47d99dd"
  client_secret   = "asp8Q~UNsJ5JWV2FNqsHJVFlZrEGSyRfQnAm4b8D"
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "Terraform"
  location = "swedencentral"
}

resource "azurerm_virtual_network" "azure_vnet" {

  address_space       = ["10.12.0.0/16"]
  location            = azurerm_resource_group.example.location
  name                = "terraform-network"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "azure_subnet" {
  name = "terraform-subnet"
  resource_group_name = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.azure_vnet.name
  address_prefixes = ["10.12.1.0/24"]
}
