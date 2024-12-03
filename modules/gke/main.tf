provider "google" {
  project = var.project_id
  region  = var.region
}
resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.location
  initial_node_count = var.initial_node_count
  
  node_config {
    machine_type = var.node_machine_type
  }
}
output "cluster_name" {
  value = google_container_cluster.gke_cluster.name
}
output "cluster_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}
variable "region" {
  description = "The region for GKE cluster"
  type        = string
}
variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}
variable "initial_node_count" {
  description = "Initial number of nodes in GKE"
  type        = number
  default     = 1
}
variable "node_machine_type" {
  description = "Machine type for the GKE nodes"
  type        = string
  default     = "e2-medium"
}
variable "location" {
  description = "The location for the GKE cluster"  
  type        = string
  default     = "us-central1"
}                  