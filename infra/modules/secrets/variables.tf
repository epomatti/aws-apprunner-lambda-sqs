variable "workload" {
  type = string
}

variable "lambda_password" {
  type      = string
  sensitive = true
}
