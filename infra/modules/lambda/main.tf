locals {
  # Zipped with `zip lambda.zip app.py`
  filename = "${path.module}/handler/lambda.zip"
}

resource "aws_lambda_function" "sqs" {
  function_name    = var.name
  description      = "Lambda function for processing SQS messages"
  role             = var.execution_role_arn
  filename         = local.filename
  source_code_hash = filebase64sha256(local.filename)
  runtime          = "python3.12"
  handler          = "app.lambda_handler"

  memory_size = var.memory_size
  timeout     = var.timeout

  environment {
    variables = {
      SQS_QUEUE_NAME = var.sqs_queue_name
    }
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash
    ]
  }
}

# resource "aws_lambda_event_source_mapping" "sqs" {
#   event_source_arn  = aws_dynamodb_table.accounts.stream_arn
#   function_name     = aws_lambda_function.sqs.arn
#   starting_position = "LATEST"
# }
