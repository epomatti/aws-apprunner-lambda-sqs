output "lambda_secret_name" {
  value = aws_secretsmanager_secret.lambda.name
}

output "local_lambda_secret_arn" {
  value = aws_secretsmanager_secret.local.arn
}

output "local_lambda_secret_name" {
  value = aws_secretsmanager_secret.local.name
}
