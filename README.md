![Latest GitHub Release](https://img.shields.io/github/v/release/byu-oit/terraform-aws-ses?sort=semver)

# terraform-aws-ses
Configures and verifies a domain in AWS SES.

#### [New to Terraform Modules at BYU?](https://github.com/byu-oit/terraform-documentation)

## Usage
```hcl
data "aws_route53_zone" "mysubdomain" {
  name         = "mysubdomain.byu.edu."
}

module "ses" {
  source = "github.com/byu-oit/terraform-aws-ses?ref=v1.0.0"
  domain_name = "mysubdomain.byu.edu"
  hosted_zone_id = data.aws_route53_zone.mysubdomain
}
```

## Requirements
* Terraform version 0.12.16 or greater
* You must already have a Route53 Hosted Zone setup for your domain, with proper NS routing setup in the parent DNS.

## Email Verification
After applying this module, you will see a verification email inside the `mail_from_inbox_bucket_name` S3 bucket. Open that email and go to the verification link. You should then be able to use SES to send emails.

## Sandbox Mode
Your SES Domain starts off in sandbox mode. In sandbox mode, you will be restricted on how many emails you can send, and you can only send to verfied recipients. To get out of sandbox mode, you need to open a support ticket with AWS. There is a specific ticket type for SES limit increases that you should use.

## Inputs
| Name | Type  | Description | Default |
| --- | --- | --- | --- |
| domain_name | string | | |
| hosted_zone_id | string | | |
| rule_set_name | string | | |
| mail_from_email_address | string | | reply@<domain_name> |
| mail_from_inbox_bucket_name | string | | ses-inbox-<domain_name> |

## Outputs
| Name | Type | Description |
| ---  | ---  | --- |
| | | |
