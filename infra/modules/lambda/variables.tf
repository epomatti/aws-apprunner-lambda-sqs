variable "name" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "sqs_queue_name" {
  type = string
}

variable "memory_size" {
  type = number
}

variable "timeout" {
  type = number
}
