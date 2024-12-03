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
  dns_prefix          = var.dns_prefix
  
  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
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
variable "resource_group_name" {
  description = "Resource group name for AKS"
  type        = string
}
variable "location" {
  description = "Azure region for the AKS cluster"
  type        = string
}
variable "vnet_cidr" {
  description = "CIDR block for the Azure VNet"
  type        = string
}
variable "subnet_cidr" {
  description = "CIDR block for AKS subnet"
  type        = string
}
variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}
variable "node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
}
variable "vm_size" {
  description = "Virtual machine size for nodes in AKS"
  type        = string
  default     = "Standard_DS2_v2"
}
variable "cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}