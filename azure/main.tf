provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
}
resource "azurerm_virtual_network" "aks_vnet" {
  name                = "${var.cluster_name}-vnet"
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}
resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.cluster_name}-subnet"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = [var.subnet_cidr]
}
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  sku_tier           = "Free"
  dns_prefix         = var.dns_prefix
  
  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size   = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }
  identity {
    type = "SystemAssigned"
  }
}
output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}
output "cluster_kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_admin_config
}
#variables
variable "resource_group_name" {
  description = "The name of the resource group"
  default     = "my-aks-rg"
}
variable "location" {
  description = "The Azure region to deploy to"
  default     = "West US"
}
variable "vnet_cidr" {
  description = "CIDR block for the VNet"
  default     = "10.0.0.0/16"
}
variable "subnet_cidr" {
  description = "CIDR block for the AKS subnet"
  default     = "10.0.1.0/24"
}
variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  default     = "myaks"
}
variable "node_count" {
  description = "Number of nodes in the AKS cluster"
  default     = 1
}
variable "cluster_name" {
  description = "The name of the AKS cluster"
  default     = "my-aks-cluster"
}