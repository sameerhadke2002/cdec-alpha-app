# Backend stack — VPC first, then EKS (uses VPC outputs)

module "vpc" {
  source = "../modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones

  cluster_name = var.cluster_name
  environment  = var.environment
  project_name = var.project_name

  single_nat_gateway = var.single_nat_gateway
  additional_tags    = var.additional_tags
}

module "eks" {
  source = "../modules/eks"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids

  node_instance_types = var.node_instance_types
  desired_size        = var.desired_size
  min_size            = var.min_size
  max_size            = var.max_size
  disk_size           = var.disk_size

  environment  = var.environment
  project_name = var.project_name

  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_private_access      = var.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  enable_cluster_autoscaler_tags = var.enable_cluster_autoscaler_tags
  additional_tags                = var.additional_tags

  depends_on = [module.vpc]
}
