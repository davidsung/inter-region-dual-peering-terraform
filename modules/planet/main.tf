data "aws_availability_zones" "all" {}

data "aws_subnet_ids" "selected" {
  vpc_id = module.vpc.vpc_id

  filter {
    name   = "availability-zone"
    values = [data.aws_availability_zones.all.names.0]
  }

  filter {
    name   = "tag:Tier"
    values = ["private"]
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}-vpc"
  cidr = var.vpc_cidr

  azs = data.aws_availability_zones.all.names
  private_subnets = [
    cidrsubnet(var.vpc_cidr, 4, 0), cidrsubnet(var.vpc_cidr, 4, 1), cidrsubnet(var.vpc_cidr, 4, 2),
    cidrsubnet(var.vpc_cidr, 4, 3), cidrsubnet(var.vpc_cidr, 4, 4), cidrsubnet(var.vpc_cidr, 4, 5)
  ]
  private_subnet_tags = { "Tier" : "private" }
  public_subnets      = [cidrsubnet(var.vpc_cidr, 4, 6), cidrsubnet(var.vpc_cidr, 4, 7), cidrsubnet(var.vpc_cidr, 4, 8)]

  enable_ipv6                                    = true
  private_subnet_ipv6_prefixes                   = range(6)
  private_subnet_assign_ipv6_address_on_creation = true

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_dns_hostnames = true

  tags = var.tags
}
