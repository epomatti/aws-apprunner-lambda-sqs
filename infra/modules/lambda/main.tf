locals {
  filename = "${path.module}/handlers/${var.lambda_handler_zip}"
}

# TODO: X-Ray
# TODO: CloudWatch Application Insights
# TODO: Structured Logging
# TODO: dead_letter_config
resource "aws_lambda_function" "sqs" {
  function_name    = var.name
  description      = "Lambda function for processing SQS messages"
  role             = var.execution_role_arn
  filename         = local.filename
  source_code_hash = filebase64sha256(local.filename)
  architectures    = var.lambda_architectures
  runtime          = var.lambda_runtime
  handler          = var.lambda_handler

  memory_size = var.memory_size
  timeout     = var.timeout

  environment {
    variables = {
      APP_RUNNER_SECRET_MANAGER_PASSWORD = var.lambda_secret_name
      APP_RUNNER_URL                     = "https://${var.apprunner_service_url}"
      APP_RUNNER_USERNAME                = var.apprunner_username
    }
  }

  # https://docs.aws.amazon.com/systems-manager/latest/userguide/ps-integration-lambda-extensions.html#ps-integration-lambda-extensions-add
  # layers = ["arn:aws:lambda:us-east-2:590474943231:layer:AWS-Parameters-and-Secrets-Lambda-Extension:11"]

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash
    ]
  }
}

resource "aws_lambda_event_source_mapping" "sqs" {
  function_name                      = aws_lambda_function.sqs.arn
  event_source_arn                   = var.sqs_queue_arn
  enabled                            = var.sqs_trigger_enabled
  batch_size                         = var.lambda_sqs_batch_size
  maximum_batching_window_in_seconds = 0
  function_response_types            = ["ReportBatchItemFailures"]

  scaling_config {
    maximum_concurrency = var.maximum_concurrency
  }
}
