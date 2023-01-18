resource "azurerm_kubernetes_cluster" "this" {
  name                = local.az_cluster_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = "prefix-aks1"

  default_node_pool {
    name       = "devpool12233"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  linux_profile {
    admin_username = "azureuser"

    ssh_key {
      key_data = file("${var.ssh_key}")
    }
  }


  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Dev"
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive = true
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate
  sensitive = true
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.this.kube_config.0.client_certificate
  sensitive = true
}

output "client_key" {
  value = azurerm_kubernetes_cluster.this.kube_config.0.client_key
  sensitive = true
}

output "host" {
  value = azurerm_kubernetes_cluster.this.kube_config.0.host
  sensitive = true
}