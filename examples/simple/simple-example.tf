provider "aws" {
  version = "~> 3.0"
  region  = "us-west-2"
}

module "ses" {
  source = "github.com/byu-oit/terraform-aws-ses?ref=v1.0.0"
  #source = "../" # for local testing during module development
}
