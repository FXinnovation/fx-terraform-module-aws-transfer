locals {
  tags = {
    managed-by = "terraform"
    Terraform  = "True"
  }

  should_create_instance_profile = var.iam_cloud_watch_iam_role_create || var.iam_s3_bucket_role_create
}


#####
# Transfer
#####

resource "aws_transfer_server" "this" {
  endpoint_type          = var.endpoint_type
  invocation_role        = var.invocation_role
  host_key               = var.host_key
  url                    = var.url
  identity_provider_type = var.identity_provider_type
  logging_role           = local.should_create_instance_profile ? element(concat(aws_iam_role.cloud_watch.*.arn, [""]), 0) : var.cloud_watch_iam_role_arn
  force_destroy          = true

  dynamic "endpoint_details" {
    for_each = var.endpoint_type == "VPC_ENDPOINT" ? [1] : []

    content {
      vpc_endpoint_id = local.should_create_vpc_endpoint ? element(concat(aws_vpc_endpoint.this.*.id, [""]), 0) : var.endpoint_type == "VPC_ENDPOINT" ? var.vpc_endpoint_id : null
    }
  }

  tags = merge(
    var.tags,
    var.transfer_server_tags,
    local.tags,
  )
}

#####
# VPC endpoint
#####

locals {
  should_create_vpc_endpoint = var.endpoint_type == "VPC_ENDPOINT" && var.create_vpc_endpoint
}

resource "aws_vpc_endpoint" "this" {
  count = local.should_create_vpc_endpoint ? 1 : 0

  service_name = format("com.amazonaws.%s.transfer.server", data.aws_region.this.name)

  vpc_id              = var.vpc_id
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = var.vpc_endpoint_private_dns_enabled
  security_group_ids  = compact(concat(aws_security_group.this.*.id, var.vpc_endpoint_security_groups))

  tags = merge(
    var.tags,
    var.vpc_endpoint_tags,
    local.tags,
    {
      Name = format("%s%s", var.prefix, var.vpc_endpoint_name)
    }
  )
}

resource "aws_vpc_endpoint_subnet_association" "this" {
  count = local.should_create_vpc_endpoint && var.subnet_ids_count > 0 ? var.subnet_ids_count : 0

  vpc_endpoint_id = element(concat(aws_vpc_endpoint.this.*.id, [""]), 0)
  subnet_id       = element(concat(var.subnet_ids, [""]), count.index)
}

#####
# Security group
#####

locals {
  security_group_needed = (length(var.allowed_cidrs) > 0 || length(var.allowed_security_group_ids) > 0) && var.endpoint_type == "VPC_ENDPOINT" && var.create_security_group
}

resource "aws_security_group" "this" {
  count = local.security_group_needed ? 1 : 0

  name        = format("%s%s", var.prefix, var.security_group_name)
  description = "AWS transfer"
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    var.security_group_tags,
    {
      Name = format("%s%s", var.prefix, var.security_group_name)
    },
    local.tags,
  )
}

resource "aws_security_group_rule" "this_in_cidr" {
  count = local.security_group_needed && length(var.allowed_cidrs) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidrs
  security_group_id = element(concat(aws_security_group.this.*.id, [""]), 0)
}

resource "aws_security_group_rule" "this_in_sg" {
  count = local.security_group_needed && var.allowed_security_group_ids_count > 0 ? var.allowed_security_group_ids_count : 0

  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = var.allowed_security_group_ids[count.index]
  security_group_id        = element(concat(aws_security_group.this.*.id, [""]), 0)
}

resource "aws_security_group_rule" "this_out_cidr" {
  count = local.security_group_needed && length(var.allowed_cidrs) > 0 ? 1 : 0

  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidrs
  security_group_id = element(concat(aws_security_group.this.*.id, [""]), 0)
}

resource "aws_security_group_rule" "this_out_sg" {
  count = local.security_group_needed && var.allowed_security_group_ids_count > 0 ? var.allowed_security_group_ids_count : 0

  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = var.allowed_security_group_ids[count.index]
  security_group_id        = element(concat(aws_security_group.this.*.id, [""]), 0)
}

#####
# Cloud watch IAM
#####

data "aws_iam_policy_document" "cloud_watch" {
  count = var.iam_cloud_watch_iam_role_create ? 1 : 0

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]

    resources = [
      format("arn:%s:logs:%s:%s:log-group:/aws/transfer/*:*", data.aws_partition.this.partition, data.aws_region.this.name, data.aws_caller_identity.this.account_id),
      format("arn:%s:logs:%s:%s:log-group:/aws/transfert/*:log-stream:*", data.aws_partition.this.partition, data.aws_region.this.name, data.aws_caller_identity.this.account_id)
    ]
  }
}

resource "aws_iam_policy" "cloud_watch" {
  count = var.iam_cloud_watch_iam_role_create ? 1 : 0

  name        = var.iam_cloud_watch_iam_policy_name != "" ? format("%s%s", var.prefix, var.iam_cloud_watch_iam_policy_name) : null
  name_prefix = var.iam_cloud_watch_iam_policy_name_prefix != "" ? format("%s%s", var.prefix, var.iam_cloud_watch_iam_policy_name_prefix) : null
  path        = var.iam_cloud_watch_iam_policy_path
  description = "Allow AWS transfer to push logs in cloud watch"

  policy = data.aws_iam_policy_document.cloud_watch.0.json
}

resource "aws_iam_role" "cloud_watch" {
  count = var.iam_cloud_watch_iam_role_create ? 1 : 0

  name               = format("%s%s", var.prefix, var.iam_cloud_watch_iam_role_name)
  description        = "Allow AWS transfer to push logs in cloud watch"
  path               = var.iam_cloud_watch_iam_role_path
  assume_role_policy = data.aws_iam_policy_document.sts_transfer.*.json[0]

  tags = merge(
    var.tags,
    var.iam_cloud_watch_role_tags,
    local.tags,
  )
}

resource "aws_iam_role_policy_attachment" "cloud_watch" {
  count = var.iam_cloud_watch_iam_role_create ? 1 : 0

  role       = aws_iam_role.cloud_watch.0.name
  policy_arn = aws_iam_policy.cloud_watch.0.arn
}
