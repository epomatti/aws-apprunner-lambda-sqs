resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/litware/lambda"
  retention_in_days = 90
}
