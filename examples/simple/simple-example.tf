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
}
