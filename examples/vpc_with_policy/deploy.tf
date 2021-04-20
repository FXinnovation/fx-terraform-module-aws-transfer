resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
  number  = false
}

locals {
  vpc_cidr = "10.0.0.0/16"
  tags = {
    tftest = true
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"

  name = random_string.this.result

  cidr = local.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = [cidrsubnet(local.vpc_cidr, 8, 0), cidrsubnet(local.vpc_cidr, 8, 1)]
  public_subnets  = [cidrsubnet(local.vpc_cidr, 8, 2), cidrsubnet(local.vpc_cidr, 8, 3)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}

module "vpc_with_policy" {
  source = "../.."

  prefix = "aws-transfer-tftest${random_string.this.result}"

  endpoint_type = "VPC_ENDPOINT"

  subnet_ids       = module.vpc.public_subnets
  subnet_ids_count = 2
  vpc_id           = module.vpc.vpc_id

  iam_cloud_watch_iam_role_create = true
  iam_cloud_watch_iam_policy_name = "cloudwatch-transfer"
  iam_cloud_watch_iam_role_name   = "cloudwatch-transfer"

  create_security_group = true
  security_group_name   = "aws_transfer"
  allowed_cidrs         = ["0.0.0.0/0"]

  create_vpc_endpoint = true
  vpc_endpoint_name   = "transfer"

  tags = local.tags
}
