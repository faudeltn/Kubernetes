module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-${var.prefix}-${var.environment}"
  cidr = var.vpc_cidr_block

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  enable_vpn_gateway   = false
  single_nat_gateway   = false

  public_subnet_tags = {
      "kubernetes.io/role/elb" = "1"
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }

  private_subnet_tags = {
      "kubernetes.io/role/internal-elb" = "1"
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}
