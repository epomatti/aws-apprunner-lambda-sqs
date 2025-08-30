### Variables ###
locals {
  availability_zone_1 = "${var.aws_region}a"
  cidr_block_prefix   = "10.0"
}

### VPC ###
resource "aws_vpc" "main" {
  cidr_block           = "${local.cidr_block_prefix}.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${var.workload}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ig-${var.workload}"
  }
}

### Subnets ###
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "${local.cidr_block_prefix}.30.0/24"
  availability_zone       = local.availability_zone_1
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.workload}-pub1"
  }
}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "${local.cidr_block_prefix}.90.0/24"
  availability_zone       = local.availability_zone_1
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.workload}-priv1"
  }
}

resource "aws_subnet" "vpce" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "${local.cidr_block_prefix}.111.0/24"
  availability_zone       = local.availability_zone_1
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.workload}-vpce"
  }
}

### Route Tables ###

resource "aws_route_table" "public1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "rt-${var.workload}-pub1"
  }
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "rt-${var.workload}-priv1"
  }
}

resource "aws_route_table" "vpce" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "rt-${var.workload}-vpce"
  }
}

### Route Table Associations ###
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public1.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "vpce" {
  subnet_id      = aws_subnet.vpce.id
  route_table_id = aws_route_table.vpce.id
}

### NAT Gateway ###
resource "aws_eip" "nat" {
  count  = var.create_nat_gateway ? 1 : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "nat-${var.workload}"
  }
}

### Route Table Routes ###
resource "aws_route" "public_subnet1_to_gateway" {
  route_table_id         = aws_route_table.public1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route" "private_subnet1_to_nat_gateway" {
  count                  = var.create_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[0].id
}

### REMOVE DEFAULT ###
resource "aws_default_route_table" "internet" {
  default_route_table_id = aws_vpc.main.default_route_table_id
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id
}
