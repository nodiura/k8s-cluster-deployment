provider "google" {
  project = var.project_id
  region  = var.region
}
resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.region
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
#variables 
variable "project_id" {
  description = "The GCP project ID"
}
variable "region" {
  description = "The GCP region to deploy to"
  default     = "us-central1"
}
variable "cluster_name" {
  description = "The name of the GKE cluster"
  default     = "my-gke-cluster"
}
variable "initial_node_count" {
  description = "Initial number of nodes in the GKE cluster"
  default     = 1
}
variable "node_machine_type" {
  description = "The machine type for the nodes"
  default     = "e2-medium"
}