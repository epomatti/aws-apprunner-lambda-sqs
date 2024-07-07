resource "aws_apprunner_service" "main" {
  service_name = "app-${var.workload}"

  instance_configuration {
    cpu               = var.cpu
    memory            = var.memory
    instance_role_arn = var.instance_role_arn
  }

  network_configuration {
    ingress_configuration {
      is_publicly_accessible = true
    }
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.connector.arn
    }
  }

  source_configuration {
    auto_deployments_enabled = true

    image_repository {
      image_repository_type = "ECR"
      image_identifier      = "${var.repository_url}:${var.image_tag}"

      image_configuration {
        port = "8080"
      }
    }

    authentication_configuration {
      access_role_arn = var.access_role_arn
    }
  }

  health_check_configuration {
    protocol = "HTTP"
    path     = "/actuator/health"
  }

  observability_configuration {
    observability_enabled = false
  }
}

resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "vpcconn-${var.workload}"
  subnets            = var.private_subnets
  security_groups    = [aws_security_group.main.id]
}

### Security Groups ###
resource "aws_security_group" "main" {
  name        = "apprunner-${var.workload}"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg-apprunner-${var.workload}"
  }
}

resource "aws_security_group_rule" "egress_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "egress_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
}
