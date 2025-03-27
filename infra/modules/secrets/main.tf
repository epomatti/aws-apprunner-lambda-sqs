resource "aws_secretsmanager_secret" "lambda" {
  name                    = "/${var.workload}/lambda/payment-api-password"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "lambda" {
  secret_id     = aws_secretsmanager_secret.lambda.id
  secret_string = var.lambda_password
}

resource "aws_secretsmanager_secret" "local" {
  name                    = "/${var.workload}/lambda/payment-api-password/local"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "local" {
  secret_id     = aws_secretsmanager_secret.local.id
  secret_string = var.lambda_password
}
