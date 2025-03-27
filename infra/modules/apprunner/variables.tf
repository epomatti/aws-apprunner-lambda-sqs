variable "workload" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "cpu" {
  type = string
}

variable "memory" {
  type = string
}

variable "repository_url" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "instance_role_arn" {
  type = string
}

variable "access_role_arn" {
  type = string
}

variable "ssm_lambda_username_secret_arn" {
  type = string
}

variable "ssm_lambda_password_secret_arn" {
  type = string
}
