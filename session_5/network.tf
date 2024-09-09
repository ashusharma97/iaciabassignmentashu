module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.3"

  name = format("%s-vpc", var.prefix)
  cidr = var.vpc_cidr

  azs             = ["ap-southeast-2a", "ap-southeast-2b"]
  public_subnets  = [cidrsubnet(var.vpc_cidr, 3, 1), cidrsubnet(var.vpc_cidr, 3, 2)]
  private_subnets = [cidrsubnet(var.vpc_cidr, 3, 3), cidrsubnet(var.vpc_cidr, 3, 4)]
  intra_subnets   = [cidrsubnet(var.vpc_cidr, 3, 5), cidrsubnet(var.vpc_cidr, 3, 6)]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "Demo"
  }
}
