terraform {
  required_version = "0.12.26"
}

provider "aws" {
  version = "~> 3.0"
  region  = "us-west-2"
}

module "acs" {
  source = "github.com/byu-oit/terraform-aws-acs-info?ref=v3.1.0"
}

resource "aws_ses_receipt_rule_set" "default" {
  rule_set_name = "default-rule-set"
}

module "ci_test" {
  source         = "../../"
  domain_name    = module.acs.route53_zone.name
  hosted_zone_id = module.acs.route53_zone.id
  rule_set_name  = aws_ses_receipt_rule_set.default.rule_set_name
}
