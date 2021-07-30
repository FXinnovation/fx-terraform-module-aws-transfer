data "aws_partition" "this" {}

data "aws_caller_identity" "this" {}

data "aws_region" "this" {}

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

data "aws_vpc_endpoint" "this" {
  count = var.endpoint_type == "VPC" ? 1 : 0
  filter {
    name   = "vpc-endpoint-id"
    values = [aws_transfer_server.this.endpoint_details.0.vpc_endpoint_id]
  }
}
