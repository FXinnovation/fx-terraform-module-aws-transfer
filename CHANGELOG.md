
## 4.0.0

* (BREAKING) chore: pins `pre-commit-hooks` to `v4.0.1`.
* (BREAKING) chore: bumps `s3` module version to last release.
* (BREAKING) refactor: use mirror `vpc` module from internal VCS.
* feat: add `pre-commit-afcmf` (`v0.1.2`).
* chore: pins `terraform` to `>= 0.14`.
* chore: pins `aws` provider to `>= 3.5`.
* chore: pins `pre-commit-terraform` to `v1.50.0`.
* chore: bumps `terraform` + providers versions in examples:
  - pins `terraform` to `>= 0.14`.
  - pins `aws` provider to `>= 3.5`.
  - pins `random` provider to `>= 3.0`.
* chore: pins bucket-s3 module to v4.0.0
* chore: pins vac module to v3.7.0
* refactor: get rid of useless `providers.tf` in root module.
* refactor: use SSH in module source.
* refactor: use ssh for module import.

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
