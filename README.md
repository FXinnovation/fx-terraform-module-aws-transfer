# terraform-module-aws-transfer

This module create AWS Transfer

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.0 |
| aws | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) |
| [aws_partition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |
| [aws_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) |
| [aws_transfer_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_server) |
| [aws_vpc_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) |
| [aws_vpc_endpoint_subnet_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_subnet_association) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address\_allocation\_ids | A list of address allocation IDs that are required to attach an Elastic IP address to your SFTP server's endpoint. | `list(string)` | `[]` | no |
| allowed\_cidrs | List of CIDRs to allow in AWS Transfer | `list(string)` | `[]` | no |
| allowed\_security\_group\_ids | List of security group ID to be allow im AWS Transfer | `list(string)` | `[]` | no |
| allowed\_security\_group\_ids\_count | Number of security group in `allowed_security_group_ids` | `number` | `0` | no |
| cloud\_watch\_iam\_role\_arn | Amazon Resource Name (ARN) of an IAM role that allows the service to write your SFTP users’ activity to your Amazon CloudWatch logs for monitoring and auditing purposes | `string` | `null` | no |
| create\_security\_group | Create a security group to be added to the VPC endpoint | `bool` | `false` | no |
| create\_vpc\_endpoint | Enable VPC transfer enpoint creation | `bool` | `false` | no |
| endpoint\_type | he type of endpoint that you want your SFTP server connect to. If you connect to a VPC (or VPC\_ENDPOINT), your SFTP server isn't accessible over the public internet. If you want to connect your SFTP server via public internet, set PUBLIC. Defaults to PUBLIC | `string` | `"PUBLIC"` | no |
| host\_key | RSA private key | `string` | `null` | no |
| iam\_cloud\_watch\_iam\_policy\_name | Name of the cloud watch policy if `iam_cloud_watch_iam_role_create` is set | `string` | `""` | no |
| iam\_cloud\_watch\_iam\_policy\_name\_prefix | Prefix name of the cloud watch policy if `iam_cloud_watch_iam_role_create` is set | `string` | `""` | no |
| iam\_cloud\_watch\_iam\_policy\_path | Path of the cloud watch policy if `iam_cloud_watch_iam_role_create` is set | `string` | `"/"` | no |
| iam\_cloud\_watch\_iam\_role\_create | Create the cloud watch IAM role. | `bool` | `false` | no |
| iam\_cloud\_watch\_iam\_role\_name | Name of the cloud watch role if `iam_cloud_watch_iam_role_create` is set | `string` | `""` | no |
| iam\_cloud\_watch\_iam\_role\_path | Path of the cloud watch role if `iam_cloud_watch_iam_role_create` is set | `string` | `"/"` | no |
| iam\_cloud\_watch\_role\_tags | Tags to be merge with cloudwatch IAM role | `map` | `{}` | no |
| iam\_s3\_bucket\_role\_create | Create the cloud watch IAM role. | `bool` | `false` | no |
| identity\_provider\_type | The mode of authentication enabled for this service. The default value is SERVICE\_MANAGED, which allows you to store and access SFTP user credentials within the service. API\_GATEWAY indicates that user authentication requires a call to an API Gateway endpoint URL provided by you to integrate an identity provider of your choice. | `string` | `"SERVICE_MANAGED"` | no |
| invocation\_role | Amazon Resource Name (ARN) of the IAM role used to authenticate the user account with an identity\_provider\_type of API\_GATEWAY | `string` | `null` | no |
| prefix | Prefix to be add to all unique resources | `string` | `""` | no |
| security\_group\_name | Name of the security group | `string` | `null` | no |
| security\_group\_tags | Tags to be merged with security group | `map(string)` | `{}` | no |
| subnet\_ids | A list of subnet IDs that are required to host your SFTP server endpoint in your VPC. | `list(string)` | `[]` | no |
| subnet\_ids\_count | Number of subnet IDs | `number` | `0` | no |
| tags | Tags to be merged with all resources of this module | `map` | `{}` | no |
| transfer\_server\_tags | Tags to be merged with the transfer server resource | `map` | `{}` | no |
| url | URL of the service endpoint used to authenticate users with an identity\_provider\_type of API\_GATEWAY | `string` | `null` | no |
| vpc\_endpoint\_id | The ID of the VPC endpoint. This property can only be used when endpoint\_type is set to VPC\_ENDPOINT | `string` | `null` | no |
| vpc\_endpoint\_name | Name of the VPC transfer endpoint | `string` | `null` | no |
| vpc\_endpoint\_private\_dns\_enabled | Enable private DNS on VPC transfer endpoint | `bool` | `false` | no |
| vpc\_endpoint\_security\_groups | List of security group IDs to be added to VPC transfer endpoint | `list(string)` | `[]` | no |
| vpc\_endpoint\_tags | Tags to be merge with VPC transfer endpoint | `map(string)` | `{}` | no |
| vpc\_id | The VPC ID of the virtual private cloud in which the SFTP server's endpoint will be hosted. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | n/a |
| endpoint | n/a |
| host\_key\_fingerprint | n/a |
| iam\_cloud\_watch\_iam\_policy\_arn | n/a |
| iam\_cloud\_watch\_iam\_policy\_name | n/a |
| iam\_cloud\_watch\_iam\_role\_arn | n/a |
| iam\_cloud\_watch\_iam\_role\_name | n/a |
| id | n/a |
| security\_group\_arn | n/a |
| security\_group\_id | n/a |
| vpc\_endpoint\_arn | n/a |
| vpc\_endpoint\_dns\_entry | n/a |
| vpc\_endpoint\_id | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Versioning
This repository follows [Semantic Versioning 2.0.0](https://semver.org/)

## Git Hooks
This repository uses [pre-commit](https://pre-commit.com/) hooks.
