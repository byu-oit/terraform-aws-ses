![Latest GitHub Release](https://img.shields.io/github/v/release/byu-oit/terraform-aws-ses?sort=semver)

# terraform-aws-ses
Configures and verifies a domain in AWS SES.

#### [New to Terraform Modules at BYU?](https://github.com/byu-oit/terraform-documentation)

## Usage
```hcl
module "ses" {
  source = "github.com/byu-oit/terraform-aws-ses?ref=v1.0.0"
}
```

## Requirements
* Terraform version 0.12.16 or greater

## Inputs
| Name | Type  | Description | Default |
| --- | --- | --- | --- |
| domain_name | string | | |
| hosted_zone_id | string | | |
| verification_email_address | string | | verify@<domain_name> |
| verification_bucket_name | string | | ses_verify_<domain_name> |

## Outputs
| Name | Type | Description |
| ---  | ---  | --- |
| | | |
