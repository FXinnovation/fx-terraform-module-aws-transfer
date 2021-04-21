# VPC private endpoint example

With IAM role create and VPC Endpoint creation

## Usage

```
# terraform init
# terraform apply
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.0 |
| aws | >= 2.0 |
| random | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |
| random | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| s3 | git::https://scm.dazzlingwrench.fxinnovation.com/fxinnovation-public/terraform-module-aws-bucket-s3.git?ref=2.1.0 |  |
| vpc | terraform-aws-modules/vpc/aws | 2.78.0 |
| vpc_with_policy | ../.. |  |

## Resources

| Name |
|------|
| [aws_availability_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_key | Credentials: AWS access key. | `string` | n/a | yes |
| secret\_key | Credentials: AWS secret key. Pass this as a variable, never write password in the code. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| vpc\_with\_policy | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
