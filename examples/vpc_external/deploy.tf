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

data "aws_region" "current" {}

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

resource "aws_vpc_endpoint" "example" {
  service_name = format("com.amazonaws.%s.transfer.server", data.aws_region.current.name)

  vpc_id = module.vpc.vpc_id
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.example.id]
  subnet_ids = module.vpc.private_subnets

  tags = merge(
    local.tags,
    {
      Name = random_string.this.result,
    },
  )
}

resource "aws_security_group" "example" {
  name        = random_string.this.result
  vpc_id      = module.vpc.vpc_id

  tags = merge(
    local.tags,
    {
      Name = random_string.this.result,
    },
  )
}


module "vpc_external_vpce" { 
  source = "../.."

  prefix = "aws-transfer-tftest${random_string.this.result}"

  endpoint_type = "VPC_ENDPOINT"

  vpc_endpoint_id = aws_vpc_endpoint.example.id
  
  tags = local.tags
}
