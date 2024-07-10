variable "workload" {
  type = string
}

variable "lambda_username" {
  type      = string
  sensitive = true
}

variable "lambda_password" {
  type      = string
  sensitive = true
}
