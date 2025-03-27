variable "workload" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_route_tables" {
  type = list(string)
}
