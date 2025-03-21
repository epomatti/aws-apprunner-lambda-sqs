### General ###
variable "aws_region" {
  type = string
}

variable "workload" {
  type = string
}

### ECR ###
variable "ecr_image_tag" {
  type = string
}

### App Runner ###
variable "enable_app_runner" {
  type = bool
}

variable "app_runner_cpu" {
  type = string
}

variable "app_runner_memory" {
  type = string
}

### Lambda ###
variable "lambda_handler_zip" {
  type = string
}

variable "lambda_memory_size" {
  type = number
}

variable "lambda_timeout" {
  type = number
}

variable "lambda_sqs_trigger_enabled" {
  type = bool
}

variable "lambda_username" {
  type      = string
  sensitive = true
}

variable "lambda_password" {
  type      = string
  sensitive = true
}

variable "lambda_architectures" {
  type = list(string)
}

variable "lambda_runtime" {
  type = string
}

variable "lambda_handler" {
  type = string
}
