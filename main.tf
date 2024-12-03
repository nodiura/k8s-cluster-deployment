terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  region = var.aws_region
}
provider "azurerm" {
  features {}
}
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}
module "eks" {
  source           = "./modules/eks"
  region           = var.aws_region
  vpc_cidr         = var.vpc_cidr
  subnet_cidrs     = var.subnet_cidrs
  availability_zones = var.availability_zones
  cluster_name     = "my-eks-cluster"
}
module "aks" {
  source                    = "./modules/aks"
  resource_group_name      = var.azure_resource_group_name
  location                 = var.azure_region
  vnet_cidr                = var.azure_vnet_cidr
  subnet_cidr              = var.azure_subnet_cidr
  dns_prefix               = var.azure_dns_prefix
  node_count               = var.azure_node_count
  cluster_name             = "my-aks-cluster"
}
module "gke" {
  source              = "./modules/gke"
  project_id         = var.gcp_project_id
  region             = var.gcp_region
  location           = var.location
  cluster_name       = "my-gke-cluster"
  initial_node_count = var.gke_initial_node_count
  node_machine_type  = var.gke_node_machine_type
}
#variables
variable "aws_region" {
  description = "AWS region for EKS"
  default     = "us-west-2"
}
variable "vpc_cidr" {
  description = "CIDR block for the AWS VPC"
  default     = "10.0.0.0/16"
}
variable "subnet_cidrs" {
  description = "List of CIDR blocks for the AWS subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "availability_zones" {
  description = "Availability zones for AWS"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}
variable "azure_resource_group_name" {
  description = "Resource group name for Azure"
  default     = "my-aks-rg"
}
variable "azure_region" {
  description = "Azure region for AKS"
  default     = "West US"
}
variable "location" {
  description = "The location for the GKE cluster"  
  type        = string
  default     = "us-central1"
}                  
variable "azure_vnet_cidr" {
  description = "CIDR for Azure VNet"
  default     = "10.0.0.0/16"
}
variable "azure_subnet_cidr" {
  description = "CIDR for Azure subnet"
  default     = "10.0.1.0/24"
}
variable "azure_dns_prefix" {
  description = "DNS prefix for AKS cluster"
  default     = "myaks"
}
variable "azure_node_count" {
  description = "Node count for AKS"
  default     = 1
}
variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
  default     = "my-project-id"  
}
variable "gcp_region" {
  description = "GCP region for GKE"
  default     = "us-central1"
}
variable "gke_initial_node_count" {
  description = "Initial node count for GKE"
  default     = 1
}
variable "gke_node_machine_type" {
  description = "Machine type for GKE nodes"
  default     = "e2-medium"
}
#outputs
output "eks_cluster_name" {
  value = module.eks.cluster_name
}
output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
output "aks_cluster_name" {
  value = module.aks.cluster_name
}
output "aks_cluster_kube_config" {
  value = module.aks.cluster_kube_config
}
output "gke_cluster_name" {
  value = module.gke.cluster_name
}
output "gke_cluster_endpoint" {
  value = module.gke.cluster_endpoint
}