terraform {
  required_version = ">= 0.12.16"
  required_providers {
    aws = ">= 3.0"
  }
}

data "aws_region" "current" {}

locals {
  mail_from_email_address     = var.mail_from_email_address != null ? var.mail_from_email_address : "reply@${var.domain_name}"
  mail_from_inbox_bucket_name = var.mail_from_inbox_bucket_name != null ? var.mail_from_inbox_bucket_name : "ses-inbox-${replace(var.domain_name, ".", "-")}"
}

resource "aws_ses_domain_identity" "domain_identity" {
  domain = var.domain_name
}

resource "aws_ses_domain_dkim" "dkim" {
  domain = aws_ses_domain_identity.domain_identity.domain
}

resource "aws_route53_record" "dkim_record" {
  count   = 3
  zone_id = var.hosted_zone_id
  name    = "${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}._domainkey.${aws_ses_domain_dkim.dkim.domain}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_route53_record" "domain_verification_record" {
  zone_id = var.hosted_zone_id
  name    = "_amazonses.${aws_ses_domain_identity.domain_identity.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.domain_identity.verification_token]
}

resource "aws_ses_domain_identity_verification" "domain_verification" {
  domain     = aws_ses_domain_identity.domain_identity.id
  depends_on = [aws_route53_record.domain_verification_record]
}

resource "aws_ses_domain_mail_from" "mail_from" {
  domain           = aws_ses_domain_identity.domain_identity.domain
  mail_from_domain = "bounce.${aws_ses_domain_identity.domain_identity.domain}"
}

resource "aws_route53_record" "mx_record" {
  zone_id = var.hosted_zone_id
  name    = aws_ses_domain_mail_from.mail_from.mail_from_domain
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.${data.aws_region.current.name}.amazonses.com"]
}

resource "aws_route53_record" "spf_record" {
  zone_id = var.hosted_zone_id
  name    = aws_ses_domain_mail_from.mail_from.mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

resource "aws_ses_email_identity" "email_identity" {
  email = local.mail_from_email_address
}

data "aws_iam_policy_document" "send_email" {
  statement {
    actions   = ["SES:SendEmail", "SES:SendRawEmail"]
    resources = [aws_ses_domain_identity.domain_identity.arn]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
  }
}

resource "aws_ses_identity_policy" "send_email" {
  identity = aws_ses_domain_identity.domain_identity.arn
  name     = "${replace(aws_ses_domain_identity.domain_identity.domain, ".", "-")}-send-email"
  policy   = data.aws_iam_policy_document.send_email.json
}

resource "aws_s3_bucket" "inbox" {
  bucket = local.mail_from_inbox_bucket_name
  acl    = "private"
}

resource "aws_ses_receipt_rule" "store" {
  name          = "store"
  rule_set_name = "default-rule-set"
  recipients    = [aws_ses_email_identity.email_identity.email]
  enabled       = true
  scan_enabled  = true

  s3_action {
    bucket_name = aws_s3_bucket.inbox.bucket
    position    = 1
  }
}
