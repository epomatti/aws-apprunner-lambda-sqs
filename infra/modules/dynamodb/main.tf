resource "aws_dynamodb_table" "lambda" {
  name                        = "lambda-monitor"
  billing_mode                = "PAY_PER_REQUEST"
  stream_enabled              = false
  hash_key                    = "sqsMessageId"
  deletion_protection_enabled = false

  ttl {
    attribute_name = "expireAt"
    enabled        = true
  }

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = false
  }

  attribute {
    name = "sqsMessageId"
    type = "S"
  }

  # attribute {
  #   name = "wallet"
  #   type = "S"
  # }

  # global_secondary_index {
  #   name            = "wallet-index"
  #   hash_key        = "wallet"
  #   projection_type = "ALL"
  # }
}

### Gateway Endpoints ###
# resource "aws_vpc_endpoint" "dynamodb" {
#   for_each          = toset(var.private_route_tables)
#   vpc_id            = var.vpc_id
#   service_name      = "com.amazonaws.${var.aws_region}.dynamodb"
#   vpc_endpoint_type = "Gateway"
#   auto_accept       = true
#   route_table_ids   = [each.key]

#   tags = {
#     Name = "endpoint-dynamodb-${var.workload}-lambda"
#   }
# }
