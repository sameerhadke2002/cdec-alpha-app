# Shared

variable "aws_region" {
  description = "AWS region for VPC and EKS."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment label (dev, qa, prod)."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for naming and tags."
  type        = string
  default     = "cdec"
}

variable "cluster_name" {
  description = "EKS cluster name (also used for VPC subnet tags)."
  type        = string
}

variable "additional_tags" {
  description = "Extra tags applied to VPC and EKS resources."
  type        = map(string)
  default     = {}
}

# VPC module

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (one per AZ)."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs (one per AZ)."
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for subnets."
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Use one NAT gateway for all private subnets (lower cost)."
  type        = bool
  default     = true
}

# EKS module

variable "kubernetes_version" {
  description = "EKS Kubernetes version. Null uses the regional default."
  type        = string
  default     = null
}

variable "node_instance_types" {
  description = "EC2 instance types for the node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_size" {
  description = "Desired worker node count."
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum worker node count."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum worker node count."
  type        = number
  default     = 4
}

variable "disk_size" {
  description = "Node root volume size (GiB)."
  type        = number
  default     = 50
}

variable "cluster_endpoint_public_access" {
  description = "Enable public Kubernetes API endpoint."
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Enable private Kubernetes API endpoint."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDRs allowed to reach the public API endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_cluster_autoscaler_tags" {
  description = "Tag node group for Cluster Autoscaler discovery."
  type        = bool
  default     = true
}
