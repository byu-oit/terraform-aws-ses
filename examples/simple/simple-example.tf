provider "aws" {
  version = "~> 3.0"
  region  = "us-west-2"
}

data "aws_route53_zone" "mysubdomain" {
  name = "mysubdomain.byu.edu."
}

module "ses" {
  source         = "github.com/byu-oit/terraform-aws-ses?ref=v1.0.0"
  domain_name    = "mysubdomain.byu.edu"
  hosted_zone_id = data.aws_route53_zone.mysubdomain
	# Terraform's AWS provider doesn't have a data source to look this up.
	# So you'll need to go into the SES console to get the name of your
	# active rule-set.
	# You might need to create one and activate it.
  rule_set_name  = "default-rule-set"
}
