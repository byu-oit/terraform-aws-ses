output "note" {
	value = <<EOF
You should now see a verification email inside the ${local.mail_from_inbox_bucket_name} S3 bucket. Open that email and go to the verification link. You should then be able to use SES to send emails.

Your SES Domain starts off in sandbox mode. In sandbox mode, you will be restricted on how many emails you can send, and you can only send to verfied recipients. To get out of sandbox mode, you need to open a support ticket with AWS. There is a specific ticket type for SES limit increases that you should use.
EOF
}

