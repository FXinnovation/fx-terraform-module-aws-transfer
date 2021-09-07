# terraform-module-aws-transfer

This module create AWS Transfer

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_user"></a> [user](#module\_user) | ./modules/user | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.cloud_watch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cloud_watch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloud_watch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.this_in_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_in_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_out_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_out_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_transfer_server.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_server) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.cloud_watch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sts_transfer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | The Amazon Resource Name (ARN) of the AWS Certificate Manager (ACM) certificate. This is required when protocols is set to FTPS | `string` | `null` | no |
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | List of CIDRs to allow in AWS Transfer | `list(string)` | `[]` | no |
| <a name="input_allowed_security_group_ids"></a> [allowed\_security\_group\_ids](#input\_allowed\_security\_group\_ids) | List of security group ID to be allow im AWS Transfer | `list(string)` | `[]` | no |
| <a name="input_allowed_security_group_ids_count"></a> [allowed\_security\_group\_ids\_count](#input\_allowed\_security\_group\_ids\_count) | Number of security group in `allowed_security_group_ids` | `number` | `0` | no |
| <a name="input_cloud_watch_iam_role_arn"></a> [cloud\_watch\_iam\_role\_arn](#input\_cloud\_watch\_iam\_role\_arn) | Amazon Resource Name (ARN) of an IAM role that allows the service to write your SFTP users’ activity to your Amazon CloudWatch logs for monitoring and auditing purposes | `string` | `null` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Create a security group to be added to the VPC endpoint | `bool` | `false` | no |
| <a name="input_endpoint_type"></a> [endpoint\_type](#input\_endpoint\_type) | The type of endpoint that you want your SFTP server connect to. If you connect to a VPC (or VPC\_ENDPOINT), your SFTP server isn't accessible over the public internet. If you want to connect your SFTP server via public internet, set PUBLIC. Defaults to PUBLIC | `string` | `"PUBLIC"` | no |
| <a name="input_host_key"></a> [host\_key](#input\_host\_key) | RSA private key | `string` | `null` | no |
| <a name="input_iam_cloud_watch_iam_policy_name"></a> [iam\_cloud\_watch\_iam\_policy\_name](#input\_iam\_cloud\_watch\_iam\_policy\_name) | Name of the cloud watch policy if `iam_cloud_watch_iam_role_create` is set | `string` | `""` | no |
| <a name="input_iam_cloud_watch_iam_policy_name_prefix"></a> [iam\_cloud\_watch\_iam\_policy\_name\_prefix](#input\_iam\_cloud\_watch\_iam\_policy\_name\_prefix) | Prefix name of the cloud watch policy if `iam_cloud_watch_iam_role_create` is set | `string` | `""` | no |
| <a name="input_iam_cloud_watch_iam_policy_path"></a> [iam\_cloud\_watch\_iam\_policy\_path](#input\_iam\_cloud\_watch\_iam\_policy\_path) | Path of the cloud watch policy if `iam_cloud_watch_iam_role_create` is set | `string` | `"/"` | no |
| <a name="input_iam_cloud_watch_iam_role_create"></a> [iam\_cloud\_watch\_iam\_role\_create](#input\_iam\_cloud\_watch\_iam\_role\_create) | Create the cloud watch IAM role. | `bool` | `false` | no |
| <a name="input_iam_cloud_watch_iam_role_name"></a> [iam\_cloud\_watch\_iam\_role\_name](#input\_iam\_cloud\_watch\_iam\_role\_name) | Name of the cloud watch role if `iam_cloud_watch_iam_role_create` is set | `string` | `""` | no |
| <a name="input_iam_cloud_watch_iam_role_path"></a> [iam\_cloud\_watch\_iam\_role\_path](#input\_iam\_cloud\_watch\_iam\_role\_path) | Path of the cloud watch role if `iam_cloud_watch_iam_role_create` is set | `string` | `"/"` | no |
| <a name="input_iam_cloud_watch_role_tags"></a> [iam\_cloud\_watch\_role\_tags](#input\_iam\_cloud\_watch\_role\_tags) | Tags to be merge with cloudwatch IAM role | `map` | `{}` | no |
| <a name="input_iam_s3_bucket_role_create"></a> [iam\_s3\_bucket\_role\_create](#input\_iam\_s3\_bucket\_role\_create) | Create the cloud watch IAM role. | `bool` | `false` | no |
| <a name="input_identity_provider_type"></a> [identity\_provider\_type](#input\_identity\_provider\_type) | The mode of authentication enabled for this service. The default value is SERVICE\_MANAGED, which allows you to store and access SFTP user credentials within the service. API\_GATEWAY indicates that user authentication requires a call to an API Gateway endpoint URL provided by you to integrate an identity provider of your choice. | `string` | `"SERVICE_MANAGED"` | no |
| <a name="input_invocation_role"></a> [invocation\_role](#input\_invocation\_role) | Amazon Resource Name (ARN) of the IAM role used to authenticate the user account with an identity\_provider\_type of API\_GATEWAY | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix to be add to all unique resources | `string` | `""` | no |
| <a name="input_protocols"></a> [protocols](#input\_protocols) | Specifies the file transfer protocol or protocols over which your file transfer protocol client can connect to your server's endpoint | `list(string)` | <pre>[<br>  "SFTP"<br>]</pre> | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name of the security group | `string` | `null` | no |
| <a name="input_security_group_tags"></a> [security\_group\_tags](#input\_security\_group\_tags) | Tags to be merged with security group | `map(string)` | `{}` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs that are required to host your SFTP server endpoint in your VPC. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be merged with all resources of this module | `map` | `{}` | no |
| <a name="input_transfer_server_tags"></a> [transfer\_server\_tags](#input\_transfer\_server\_tags) | Tags to be merged with the transfer server resource | `map` | `{}` | no |
| <a name="input_url"></a> [url](#input\_url) | URL of the service endpoint used to authenticate users with an identity\_provider\_type of API\_GATEWAY | `string` | `null` | no |
| <a name="input_user_tags"></a> [user\_tags](#input\_user\_tags) | Tags to be merge with all transfer users | `map(string)` | `{}` | no |
| <a name="input_users"></a> [users](#input\_users) | A list of object that represent a user:<br> * username (mandatory): The username<br> * public\_ssh\_keys (mandatory): List of public ssh keys to associate with the user<br> * s3\_bucket\_name (mandatory): The S3 bucket to associate with the user<br> * home\_directory (optional): The S3 home directory. Default to /<br> * user\_policy\_json (optional): An IAM JSON policy document that scopes down user access to portions of their Amazon S3 bucket.<br> * server\_role\_arn (mandatory): The ARN of an IAM role that allows the service to controls your user’s access to your Amazon S3 bucket.<br> * tags (optional): Tags to be merge to the user<br> * home\_directory\_mappings (optional): Map of logical directory mappings that specify what S3 paths and keys should be visible to your user and how you want to make them visible.<br>    This map must have the following keys:<br>      * entry: Represents an entry and a target.<br>      * target: Represents the map target. | <pre>list(object({<br>    username         = string<br>    public_ssh_keys  = list(string)<br>    s3_bucket_name   = string<br>    home_directory   = optional(string)<br>    user_policy_json = optional(string)<br>    server_role_arn  = string<br>    tags             = optional(map(string))<br>    home_directory_mappings = optional(list(object({<br>      entry  = string<br>      target = string<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_vpc_address_allocation_ids"></a> [vpc\_address\_allocation\_ids](#input\_vpc\_address\_allocation\_ids) | A list of address allocation IDs that are required to attach an Elastic IP address to your SFTP server's endpoint. | `list(string)` | `[]` | no |
| <a name="input_vpc_endpoint_id"></a> [vpc\_endpoint\_id](#input\_vpc\_endpoint\_id) | The ID of the VPC endpoint. This property can only be used when endpoint\_type is set to VPC\_ENDPOINT | `string` | `null` | no |
| <a name="input_vpc_endpoint_security_groups"></a> [vpc\_endpoint\_security\_groups](#input\_vpc\_endpoint\_security\_groups) | List of security group IDs to be added to VPC transfer endpoint | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID of the virtual private cloud in which the SFTP server's endpoint will be hosted. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | n/a |
| <a name="output_host_key_fingerprint"></a> [host\_key\_fingerprint](#output\_host\_key\_fingerprint) | n/a |
| <a name="output_iam_cloud_watch_iam_policy_arn"></a> [iam\_cloud\_watch\_iam\_policy\_arn](#output\_iam\_cloud\_watch\_iam\_policy\_arn) | n/a |
| <a name="output_iam_cloud_watch_iam_policy_name"></a> [iam\_cloud\_watch\_iam\_policy\_name](#output\_iam\_cloud\_watch\_iam\_policy\_name) | n/a |
| <a name="output_iam_cloud_watch_iam_role_arn"></a> [iam\_cloud\_watch\_iam\_role\_arn](#output\_iam\_cloud\_watch\_iam\_role\_arn) | n/a |
| <a name="output_iam_cloud_watch_iam_role_name"></a> [iam\_cloud\_watch\_iam\_role\_name](#output\_iam\_cloud\_watch\_iam\_role\_name) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | n/a |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | n/a |
| <a name="output_user_arns"></a> [user\_arns](#output\_user\_arns) | n/a |
| <a name="output_vpc_endpoint_dns_name"></a> [vpc\_endpoint\_dns\_name](#output\_vpc\_endpoint\_dns\_name) | n/a |
| <a name="output_vpc_endpoint_route53_hosted_zone_id"></a> [vpc\_endpoint\_route53\_hosted\_zone\_id](#output\_vpc\_endpoint\_route53\_hosted\_zone\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Versioning
This repository follows [Semantic Versioning 2.0.0](https://semver.org/)

## Git Hooks
This repository uses [pre-commit](https://pre-commit.com/) hooks.
