variable "name" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "sqs_queue_arn" {
  type = string
}

variable "lambda_handler_zip" {
  type = string
}

variable "lambda_handler" {
  type = string
}

variable "lambda_architectures" {
  type = list(string)
}

variable "lambda_runtime" {
  type = string
}

variable "memory_size" {
  type = number
}

variable "timeout" {
  type = number
}

variable "sqs_trigger_enabled" {
  type = bool
}

variable "apprunner_service_url" {
  type = string
}

variable "lambda_secret_name" {
  type = string
}

variable "lambda_snap_start" {
  type = string
}

variable "apprunner_username" {
  type = string
}

variable "lambda_sqs_batch_size" {
  type = number
}

variable "maximum_concurrency" {
  type = number
}

variable "private_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}
