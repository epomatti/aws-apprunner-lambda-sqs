resource "aws_vpc_endpoint" "sqs" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.sqs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = [var.subnet_id]
  security_group_ids = [aws_security_group.aws_service.id]

  policy = jsonencode({
    Statement = [
      {
        Sid = "AppRunner"
        Action = [
          "sqs:SendMessage"
        ]
        Effect   = "Allow"
        Resource = "${var.sqs_queue_arn}"
        Principal = {
          AWS = "${var.apprunner_instance_role_arn}"
        }
      },
      {
        Sid = "Lambda"
        Action = [
          "sqs:*"
        ]
        Effect   = "Allow"
        Resource = "${var.sqs_queue_arn}"
        Principal = {
          AWS = "${var.lambda_execution_role_arn}"
        }
      }
    ]
  })

  tags = {
    Name = "sqs-vpce"
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "aws_service" {
  name        = "vpce-sqs-${var.affix}-sg"
  description = "Allow AWS Service connectivity via Interface Endpoints"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg-vpce-sqs-${var.affix}"
  }
}

resource "aws_security_group_rule" "ingress_https_endpoint" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  security_group_id = aws_security_group.aws_service.id
}

resource "aws_security_group_rule" "egress_https_endpoint" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_service.id
}

resource "aws_security_group_rule" "ingress_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  security_group_id = aws_security_group.aws_service.id
}

resource "aws_security_group_rule" "egress_icmp" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_service.id
}
