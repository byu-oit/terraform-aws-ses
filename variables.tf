variable "domain_name" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

variable "rule_set_name" {
  type = string
}

variable "mail_from_email_address" {
  type    = string
  default = null
}

variable "mail_from_inbox_bucket_name" {
  type    = string
  default = null
}

