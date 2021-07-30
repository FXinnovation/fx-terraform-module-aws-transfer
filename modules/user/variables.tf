variable "transfer_server_id" {
  description = "ID of the transfer server"
  type        = string
}

variable "username" {
  description = "Username to be created on the transfer server"
  type        = string
}

variable "public_ssh_keys" {
  description = "List of public keys portion of an SSH key pair."
  type        = list(string)
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "home_directory" {
  description = "Home directory of the S3 bucket for the username"
  type        = string
  default     = "/"
}

variable "home_directory_type" {
  description = "Type of home directory"
  type        = string
  default     = "PATH"
}

variable "user_policy_json" {
  description = "An IAM JSON policy document that scopes down user access to portions of their Amazon S3 bucket."
  type        = string
  default     = null
}

variable "server_role_arn" {
  description = "Amazon Resource Name (ARN) of an IAM role that allows the service to controls your user’s access to your Amazon S3 bucket. This role must trust relationship to transfer.awsamazon.com"
  type        = string
}

variable "home_directory_mappings" {
  description = <<-DOCUMENTATION
List of map of logical directory mappings that specify what S3 paths and keys should be visible to your user and how you want to make them visible.
This map must have the following keys:
 * entry: Represents an entry and a target.
 * target: Represents the map target.
DOCUMENTATION
  type        = list(map(string))
  default     = []
}

variable "tags" {
  description = "Tags to be merge with the username"
  type        = map(string)
  default     = {}
}
