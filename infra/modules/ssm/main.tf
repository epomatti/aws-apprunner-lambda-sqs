locals {
  path = "/${var.workload}/apprunner"
}

resource "aws_ssm_parameter" "lambda_username_secret" {
  name        = "${local.path}/lambda-username"
  description = "Username that Lambda will use to connect to App Runner."
  type        = "SecureString"
  value       = var.lambda_username
}

resource "aws_ssm_parameter" "lambda_password_secret" {
  name        = "${local.path}/lambda-password"
  description = "Password that Lambda will use to connect to App Runner."
  type        = "SecureString"
  value       = var.lambda_password
}
