#####
# Transfer
#####

output "arn" {
  value = aws_transfer_server.this.arn
}

output "id" {
  value = aws_transfer_server.this.id
}

output "endpoint" {
  value = aws_transfer_server.this.endpoint
}

output "host_key_fingerprint" {
  value = aws_transfer_server.this.host_key_fingerprint
}

output "vpc_endpoint_dns_name" {
  value = element(concat(data.aws_vpc_endpoint.this.*.dns_entry.0.dns_name, [""]), 0)
}

output "vpc_endpoint_route53_hosted_zone_id" {
  value = element(concat(data.aws_vpc_endpoint.this.*.dns_entry.0.hosted_zone_id, [""]), 0)
}

#####
# IAM
#####

output "iam_cloud_watch_iam_role_arn" {
  value = element(concat(aws_iam_role.cloud_watch.*.arn, [""]), 0)
}

output "iam_cloud_watch_iam_role_name" {
  value = element(concat(aws_iam_role.cloud_watch.*.name, [""]), 0)
}

output "iam_cloud_watch_iam_policy_arn" {
  value = element(concat(aws_iam_policy.cloud_watch.*.arn, [""]), 0)
}

output "iam_cloud_watch_iam_policy_name" {
  value = element(concat(aws_iam_policy.cloud_watch.*.name, [""]), 0)
}

#####
# VPC security group
#####

output "security_group_arn" {
  value = element(concat(aws_security_group.this.*.arn, [""]), 0)
}

output "security_group_id" {
  value = element(concat(aws_security_group.this.*.id, [""]), 0)
}

#####
# Users
#####

output "user_arns" {
  value = module.user
}
