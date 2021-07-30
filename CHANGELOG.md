## 3.0.0

* feat (BREAKING): Allow multiple SSH key per user. The attribute `public_ssh_key` of `users` object is now rename to `public_ssh_keys`
* feat: Add VPC endpoint DNS and route53 zone id outputs for VPC endpoint type.

## 2.0.0

* maintenance (BREAKING): bump minimal aws provider version to 3.49.0
* feat (BREAKING): Since provider v3.49.0, you can now use endpoint type "VPC". The service will take care of transfer familly endpoint creation
* feat: add protocols support. You can now use SFTP, FTP and FTPS
* feat: add certificate support for FTPS

## 1.2.0

* feat: aws.vpc provider to support vpc endpoint creation with vpc peering subnets

## 1.1.0

* feat: Add user management for AWS transfer
* fix: issue with vpc endpoint output that need to be refresh twice after apply to be outputs

## 1.0.0

* feat: first stable version

## 0.0.0

* feat: init
