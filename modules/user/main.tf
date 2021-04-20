resource "aws_transfer_user" "this" {
  server_id           = var.transfer_server_id
  user_name           = var.username
  home_directory      = var.home_directory_type == "PATH" ? format("/%s%s", var.s3_bucket_name, var.home_directory) : null
  home_directory_type = var.home_directory_type
  policy              = var.user_policy_json
  role                = var.server_role_arn
  tags                = var.tags

  dynamic "home_directory_mappings" {
    for_each = var.home_directory_mappings

    content {
      entry  = home_directory_mappings.value.entry
      target = format("/%s%s", var.s3_bucket_name, home_directory_mappings.value.target)
    }
  }
}

resource "aws_transfer_ssh_key" "this" {
  server_id = var.transfer_server_id
  user_name = aws_transfer_user.this.user_name
  body      = var.public_ssh_key
}
