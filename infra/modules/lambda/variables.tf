variable "name" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "sqs_queue_arn" {
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

# variable "sqs_trigger_batch_size" {
#   type = number
# }

# variable "sqs_trigger_maximum_batching_window_in_seconds" {
#   type = number
# }
