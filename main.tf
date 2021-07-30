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
    for_each = var.endpoint_type == "VPC_ENDPOINT" || var.endpoint_type == "VPC" ? [1] : []

    content {
      vpc_endpoint_id        = var.endpoint_type == "VPC_ENDPOINT" ? var.vpc_endpoint_id : null
      address_allocation_ids = var.endpoint_type == "VPC" && length(var.vpc_address_allocation_ids) > 0 ? var.vpc_address_allocation_ids : null
      security_group_ids     = var.endpoint_type == "VPC" ? compact(concat(aws_security_group.this.*.id, var.vpc_endpoint_security_groups)) : null
      subnet_ids             = var.endpoint_type == "VPC" ? var.subnet_ids : null
      vpc_id                 = var.endpoint_type == "VPC" ? var.vpc_id : null
    }
  }

  protocols = var.protocols

  certificate = contains(var.protocols, "FTPS") ? var.acm_certificate_arn : null

  tags = merge(
    var.tags,
    var.transfer_server_tags,
    local.tags,
  )
}

#####
# Security group
#####

locals {
  security_group_needed = (length(var.allowed_cidrs) > 0 || length(var.allowed_security_group_ids) > 0) && var.endpoint_type == "VPC" && var.create_security_group
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

#####
# Users
#####

module "user" {
  source = "./modules/user"

  for_each = toset(keys({ for i, r in var.users : i => r }))

  transfer_server_id = aws_transfer_server.this.id

  username        = var.users[each.value].username
  public_ssh_keys = var.users[each.value].public_ssh_keys

  s3_bucket_name      = var.users[each.value].s3_bucket_name
  home_directory      = var.users[each.value].home_directory
  home_directory_type = var.users[each.value].home_directory != null ? "PATH" : "LOGICAL"

  user_policy_json = var.users[each.value].user_policy_json
  server_role_arn  = var.users[each.value].server_role_arn

  home_directory_mappings = var.users[each.value].home_directory_mappings == null ? [] : var.users[each.value].home_directory_mappings

  tags = merge(
    var.tags,
    var.user_tags,
    var.users[each.value].tags,
    local.tags,
  )
}
