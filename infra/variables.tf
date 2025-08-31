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

### NAT Gateway ###
variable "create_nat_gateway" {
  type = bool
}

### EC2 Jump Server ###
variable "create_jumpserver" {
  type = bool
}

variable "ec2_jumpserver_ami" {
  type = string
}

variable "ec2_jumpserver_instance_type" {
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
  type = string
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

variable "lambda_snap_start" {
  type = string
}

variable "lambda_sqs_batch_size" {
  type = number
}

variable "lambda_sqs_visibility_timeout_seconds" {
  type = number
}

variable "lambda_sqs_maximum_concurrency" {
  type = number
}

variable "lambda_log_format" {
  type = string
}

variable "lambda_application_log_level" {
  type = string
}

variable "lambda_system_log_level" {
  type = string
}
