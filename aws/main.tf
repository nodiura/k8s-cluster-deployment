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
resource "aws_iam_role_policy_attachment" "eks_policy_attachment" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
output "cluster_name" {
  value = aws_eks_cluster.my_cluster.name
}
output "cluster_endpoint" {
  value = aws_eks_cluster.my_cluster.endpoint
}
#variables
variable "region" {
  description = "The AWS region to deploy to"
  default     = "us-west-2"
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
variable "subnet_cidrs" {
  description = "CIDR blocks for the subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "availability_zones" {
  description = "The availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}
variable "cluster_name" {
  description = "The name of the EKS cluster"
  default     = "my-eks-cluster"
}