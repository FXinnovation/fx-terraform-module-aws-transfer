data "aws_partition" "this" {}

data "aws_caller_identity" "this" {}

data "aws_region" "this" {}
data "aws_region" "vpc" {
  provider = aws.vpc
}

data "aws_iam_policy_document" "sts_transfer" {
  count = local.should_create_instance_profile ? 1 : 0

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
