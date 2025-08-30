output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnets" {
  value = [aws_subnet.private1.id]
}

output "public_subnets" {
  value = [aws_subnet.public1.id]
}

output "vpce_subnet" {
  value = aws_subnet.vpce.id
}
