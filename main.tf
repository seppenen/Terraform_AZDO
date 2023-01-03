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

resource "azurerm_network_security_group" "azure_security_group" {
  name                = "security-group-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "sec-rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.azure_subnet.id
  network_security_group_id = azurerm_network_security_group.azure_security_group.id
}

resource "azurerm_public_ip" "example" {
  name                    = "test-pip"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "example" {
  name                = "test-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.azure_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1ls"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22.04-LTS"
    version   = "latest"
  }
}
