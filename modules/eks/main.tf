provider "aws" {
  region = var.region
}
resource "aws_vpc" "eks_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
}
resource "aws_subnet" "eks_subnet_a" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.subnet_cidrs[0]
  availability_zone = var.availability_zones[0]
}
resource "aws_subnet" "eks_subnet_b" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.subnet_cidrs[1]
  availability_zone = var.availability_zones[1]
}
resource "aws_iam_role" "eks_role" {
  name = "${var.cluster_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Effect    = "Allow"
      Sid       = ""
    }]
  })
}
resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = [
      aws_subnet.eks_subnet_a.id,
      aws_subnet.eks_subnet_b.id,
    ]
  }
}
output "cluster_name" {
  value = aws_eks_cluster.my_cluster.name
}
output "cluster_endpoint" {
  value = aws_eks_cluster.my_cluster.endpoint
}
variable "region" {
  description = "AWS region for the EKS cluster"
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "subnet_cidrs" {
  description = "CIDR blocks for the subnets"
  type        = list(string)
}
variable "availability_zones" {
  description = "Availability zones for the subnets"
  type        = list(string)
}
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}
 