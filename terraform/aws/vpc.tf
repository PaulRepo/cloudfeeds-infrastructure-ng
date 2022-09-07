module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "${local.name_prefix}-eks-vpc"
  cidr = var.vpc_cidr
  azs  = var.az
  #azs                 = data.aws_availability_zones.available.names
  private_subnets    = var.private_subnets_cidr
  public_subnets     = var.public_subnets_cidr
  enable_nat_gateway = true
  single_nat_gateway = true
  #enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}