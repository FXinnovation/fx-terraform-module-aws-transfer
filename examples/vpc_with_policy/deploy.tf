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

  random_name = format("tftest%s", random_string.this.result)
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_iam_policy_document" "sts_transfer" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "transfer.amazonaws.com"
      ]
    }
  }
}

module "vpc" {
  source = "github.com/FXinnovation/fx-mirror-terraform-module-aws-vpc.git?ref=v3.6.0"

  name = random_string.this.result

  cidr = local.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = [cidrsubnet(local.vpc_cidr, 8, 0), cidrsubnet(local.vpc_cidr, 8, 1)]
  public_subnets  = [cidrsubnet(local.vpc_cidr, 8, 2), cidrsubnet(local.vpc_cidr, 8, 3)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}

module "s3" {
  source = "github.com/FXinnovation/fx-terraform-module-aws-bucket-s3.git?ref=3.0.0"

  name = local.random_name

  kms_key_create     = true
  kms_key_name       = local.random_name
  kms_key_alias_name = local.random_name

  iam_policy_create    = true
  iam_policy_read_name = format("%s-ro", local.random_name)
  iam_policy_full_name = format("%s-rw", local.random_name)

  tags = local.tags
}

resource "aws_iam_role" "s3" {
  name               = local.random_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sts_transfer.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.s3.name
  policy_arn = module.s3.iam_policy_full_arn
}

module "vpc_with_policy" {
  source = "../.."

  prefix = "aws-transfer-tftest${random_string.this.result}"

  endpoint_type = "VPC"

  subnet_ids = module.vpc.public_subnets
  vpc_id     = module.vpc.vpc_id

  iam_cloud_watch_iam_role_create = true
  iam_cloud_watch_iam_policy_name = "cloudwatch-transfer"
  iam_cloud_watch_iam_role_name   = "cloudwatch-transfer"

  create_security_group = true
  security_group_name   = "aws_transfer"
  allowed_cidrs         = ["0.0.0.0/0"]

  users = [
    {
      username        = local.random_name,
      public_ssh_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1uw5dMleanmYoVG81TC/mGhCcoe5/aZXCXElUEoeHAZvvEN9sP8ffFs/joc9VJbFWWz+7F/XqaI2V6+lmjETt6iuDUkyLBd8gZnRPkdMxFPphbXKN+1bf7WR4SGLTWdJ3O5zTP6C//L5NjCxiu8ZIbjoSp9EB+R3BX4i8Y/411+ant2ujUQxfZ8pMXM4CuQIzlEgco2fhFsG8ZpqHkoKp/yCqDIl4U+JlySAkdtRn/bP8Kp3ebxMxxqgpSI+yJ3TkWbCL/biLDqhXX/QyTR+t0RbchUVf+oQknT1OrARVIO8iejyUY6Bne7u1H3T4WOhJKJsrMk2oSeV7u/SC/Y12SIxiUD10M2ox3NNpcDe34/B9EX+LFsxbTJudUlq/Q/AW2pKtkmo6OxF4cjQeoYPYKMUq07dMRU5fWUlBVWUynt9fIPqmV/NGzJcYl9ugYfoJhYUAYKYmfQZ096AcZPuWN0sdKzsLOFp1v2Opz4t9A4gX8b5YIBXdTW2pMdI39SE= demo@tftest"],
      home_directory  = "/foo"
      s3_bucket_name  = module.s3.id,
      server_role_arn = aws_iam_role.s3.arn,
    },
    {
      username = format("%s-2", local.random_name),
      public_ssh_keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1uw5dMleanmYoVG81TC/mGhCcoe5/aZXCXElUEoeHAZvvEN9sP8ffFs/joc9VJbFWWz+7F/XqaI2V6+lmjETt6iuDUkyLBd8gZnRPkdMxFPphbXKN+1bf7WR4SGLTWdJ3O5zTP6C//L5NjCxiu8ZIbjoSp9EB+R3BX4i8Y/411+ant2ujUQxfZ8pMXM4CuQIzlEgco2fhFsG8ZpqHkoKp/yCqDIl4U+JlySAkdtRn/bP8Kp3ebxMxxqgpSI+yJ3TkWbCL/biLDqhXX/QyTR+t0RbchUVf+oQknT1OrARVIO8iejyUY6Bne7u1H3T4WOhJKJsrMk2oSeV7u/SC/Y12SIxiUD10M2ox3NNpcDe34/B9EX+LFsxbTJudUlq/Q/AW2pKtkmo6OxF4cjQeoYPYKMUq07dMRU5fWUlBVWUynt9fIPqmV/NGzJcYl9ugYfoJhYUAYKYmfQZ096AcZPuWN0sdKzsLOFp1v2Opz4t9A4gX8b5YIBXdTW2pMdI39SE= demo@tftest",
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsuIWQh6D22QYg2ofV9uMo2QeYytRPigK2gQdj0dWoXvppyhOjDFcgLhgejQxjrq9KumKrsbXwqM7wnlVYiROoKs4+BtGiBRTbTCZPPCpyQjSiFmigo7nsUMX3JntzqyD6892Nm2L2IinkqxvWVX1NkJVZMNd3mqSlY61th4T+wPTGvDY0A24dQ3DOFq2+37r8cxHzS3oJktzy3Aeteu3jI2zfUewLBwRehZoyte34FaiKghhC9B9jW4VilSJqRfSda+RjPV/LgA4W3FbWiiDNc1nGJWhM7fCwuDd6LKf1n6VuW3l4HxRxTUCoQWaajgKLjV3Y9tOEOOvu8gb4+NMOAiZTdYxxuWIKgUM4sMRdCiv1niDWZnFT8Qo47CgfunOnbu9Dk/TagZKKvDCOBDm3KYki65I+ZZQDb3qBInF8DEn+TzwgM2REXIbOxlMm1bdGhLFoLngy+rlF6iIFgnHNfFIZKNod6VJ6gLxvUHU/g4iJclsnceaNrMq9r9WEmf8= demo2@tftest",
      ]
      s3_bucket_name = module.s3.id,
      home_directory_mappings = [{
        entry  = "/foo.pdf",
        target = "/foo/result.pdf"
      }],
      server_role_arn = aws_iam_role.s3.arn,
      tags = {
        user = format("%s-2", local.random_name)
      }
    }
  ]

  tags = local.tags
}
