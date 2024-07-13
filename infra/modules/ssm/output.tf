output "lambda_username_parameter_name" {
  value = aws_ssm_parameter.lambda_username_secret.name
}

output "lambda_password_parameter_name" {
  value = aws_ssm_parameter.lambda_password_secret.name
}

output "lambda_username_secret_arn" {
  value = aws_ssm_parameter.lambda_username_secret.arn
}

output "lambda_password_secret_arn" {
  value = aws_ssm_parameter.lambda_password_secret.arn
}
