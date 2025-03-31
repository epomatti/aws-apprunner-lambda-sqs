locals {
  filename = "${path.module}/handlers/${var.lambda_handler_zip}"
}

resource "aws_lambda_function" "sqs" {
  function_name                      = var.name
  description                        = "Lambda function for processing SQS messages"
  role                               = var.execution_role_arn
  filename                           = local.filename
  source_code_hash                   = filebase64sha256(local.filename)
  architectures                      = var.lambda_architectures
  runtime                            = var.lambda_runtime
  handler                            = var.lambda_handler
  replace_security_groups_on_destroy = true

  memory_size = var.memory_size
  timeout     = var.timeout

  snap_start {
    apply_on = var.lambda_snap_start
  }

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [aws_security_group.lambda.id]
  }

  logging_config {
    log_format            = var.lambda_log_format
    log_group             = var.lambda_log_group_name
    application_log_level = var.lambda_application_log_level
    system_log_level      = var.lambda_system_log_level
  }

  environment {
    variables = {
      APP_RUNNER_SECRET_MANAGER_PASSWORD = var.lambda_secret_name
      APP_RUNNER_URL                     = "https://${var.apprunner_service_url}"
      APP_RUNNER_USERNAME                = var.apprunner_username
      AWS_LAMBDA_EXEC_WRAPPER            = "/opt/otel-instrument"
    }
  }

  layers = [
    "arn:aws:lambda:us-east-2:615299751070:layer:AWSOpenTelemetryDistroJava:4",
  ]

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


resource "aws_security_group" "lambda" {
  name        = "lambda-vpc"
  description = "Allow TLS outbound Lambda traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg-lambda-vpc"
  }
}

resource "aws_security_group_rule" "egress_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lambda.id
}

resource "aws_security_group_rule" "egress_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lambda.id
}
