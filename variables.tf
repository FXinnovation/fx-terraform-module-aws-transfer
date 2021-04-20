#####
# Global config
#####

variable "prefix" {
  description = "Prefix to be add to all unique resources"
  default     = ""
}

variable "tags" {
  description = "Tags to be merged with all resources of this module"
  default     = {}
}

#####
# Cloud watch IAM role
#####

variable "iam_cloud_watch_iam_policy_name" {
  description = "Name of the cloud watch policy if `iam_cloud_watch_iam_role_create` is set"
  default     = ""
}

variable "iam_cloud_watch_iam_policy_name_prefix" {
  description = "Prefix name of the cloud watch policy if `iam_cloud_watch_iam_role_create` is set"
  default     = ""
}

variable "iam_cloud_watch_iam_policy_path" {
  description = "Path of the cloud watch policy if `iam_cloud_watch_iam_role_create` is set"
  default     = "/"
}

variable "iam_cloud_watch_iam_role_create" {
  description = "Create the cloud watch IAM role."
  default     = false
}

variable "iam_cloud_watch_iam_role_name" {
  description = "Name of the cloud watch role if `iam_cloud_watch_iam_role_create` is set"
  type        = string
  default     = ""
}

variable "iam_cloud_watch_iam_role_path" {
  description = "Path of the cloud watch role if `iam_cloud_watch_iam_role_create` is set"
  default     = "/"
}

variable "iam_cloud_watch_role_tags" {
  description = "Tags to be merge with cloudwatch IAM role"
  default     = {}
}

variable "iam_s3_bucket_role_create" {
  description = "Create the cloud watch IAM role."
  default     = false
}

#####
# AWS transfer
#####

variable "cloud_watch_iam_role_arn" {
  description = "Amazon Resource Name (ARN) of an IAM role that allows the service to write your SFTP users’ activity to your Amazon CloudWatch logs for monitoring and auditing purposes"
  type        = string
  default     = null
}

variable "endpoint_type" {
  description = "The type of endpoint that you want your SFTP server connect to. If you connect to a VPC (or VPC_ENDPOINT), your SFTP server isn't accessible over the public internet. If you want to connect your SFTP server via public internet, set PUBLIC. Defaults to PUBLIC"
  default     = "PUBLIC"
}

variable "host_key" {
  description = "RSA private key"
  type        = string
  default     = null
}

variable "identity_provider_type" {
  description = "The mode of authentication enabled for this service. The default value is SERVICE_MANAGED, which allows you to store and access SFTP user credentials within the service. API_GATEWAY indicates that user authentication requires a call to an API Gateway endpoint URL provided by you to integrate an identity provider of your choice."
  default     = "SERVICE_MANAGED"
}

variable "invocation_role" {
  description = "Amazon Resource Name (ARN) of the IAM role used to authenticate the user account with an identity_provider_type of API_GATEWAY"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "A list of subnet IDs that are required to host your SFTP server endpoint in your VPC."
  type        = list(string)
  default     = []
}

variable "subnet_ids_count" {
  description = "Number of subnet IDs"
  type        = number
  default     = 0
}

variable "vpc_id" {
  description = "The VPC ID of the virtual private cloud in which the SFTP server's endpoint will be hosted."
  type        = string
  default     = null
}

variable "transfer_server_tags" {
  description = "Tags to be merged with the transfer server resource"
  default     = {}
}

variable "url" {
  description = "URL of the service endpoint used to authenticate users with an identity_provider_type of API_GATEWAY"
  type        = string
  default     = null
}

variable "vpc_endpoint_id" {
  description = "The ID of the VPC endpoint. This property can only be used when endpoint_type is set to VPC_ENDPOINT"
  type        = string
  default     = null
}

variable "address_allocation_ids" {
  description = "A list of address allocation IDs that are required to attach an Elastic IP address to your SFTP server's endpoint."
  type        = list(string)
  default     = []
}

#####
# Security group
#####

variable "create_security_group" {
  description = "Create a security group to be added to the VPC endpoint"
  default     = false
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = null
}

variable "allowed_cidrs" {
  description = "List of CIDRs to allow in AWS Transfer"
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "List of security group ID to be allow im AWS Transfer"
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids_count" {
  description = "Number of security group in `allowed_security_group_ids`"
  type        = number
  default     = 0
}

variable "security_group_tags" {
  description = "Tags to be merged with security group"
  type        = map(string)
  default     = {}
}

#####
# VPC endpoint
#####

variable "create_vpc_endpoint" {
  description = "Enable VPC transfer enpoint creation"
  default     = false
}

variable "vpc_endpoint_private_dns_enabled" {
  description = "Enable private DNS on VPC transfer endpoint"
  default     = false
}

variable "vpc_endpoint_security_groups" {
  description = "List of security group IDs to be added to VPC transfer endpoint"
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_tags" {
  description = "Tags to be merge with VPC transfer endpoint"
  type        = map(string)
  default     = {}
}

variable "vpc_endpoint_name" {
  description = "Name of the VPC transfer endpoint"
  type        = string
  default     = null
}

#####
# Users
#####
#variable "users" {
#  description = <<-DOCUMENTATION
#A list of object that represent a user:
# * username (mandatory): The username
# * public_ssh_key (mandatory): The public ssh key to associate with the user
# * s3_bucket_name (mandatory): The S3 bucket to associate with the user
# * home_directory (optional): The S3 home directory. Default to /
# * user_policy_json (optional): An IAM JSON policy document that scopes down user access to portions of their Amazon S3 bucket.
# * server_role_arn (mandatory): The ARN of an IAM role that allows the service to controls your user’s access to your Amazon S3 bucket.
# * tags (optional): Tags to be merge to the user
# * home_directory_mappings (optional): Map of logical directory mappings that specify what S3 paths and keys should be visible to your user and how you want to make them visible.
#    This map must have the following keys:
#      * entry: Represents an entry and a target.
#      * target: Represents the map target.
#DOCUMENTATION
#  type = list(object({
#    username         = string
#    public_ssh_key   = string
#    s3_bucket_name   = string
#    home_directory   = optional(string)
#    user_policy_json = optional(string)
#    server_role_arn  = string
#    tags             = optional(map(string))
#    home_directory_mappings = optional(list(object({
#      entry  = string
#      target = string
#    })))
#  }))
#  default = []
#}
#
#variable "user_tags" {
#  description = "Tags to be merge with all transfer users"
#  type        = map(string)
#  default     = {}
#}
