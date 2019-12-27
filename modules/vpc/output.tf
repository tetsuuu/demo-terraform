output "vpc_id" {
  value = aws_vpc.service_vpc.id
  description = "The VPC ID of service environment by"
}

output "public_subnets" {
  value       = [for subnet in aws_subnet.public_subnet : subnet.id]
  description = "The public subnet of service environment by"
}

output "private_subnets" {
  value       = [for subnet in aws_subnet.private_subnet : subnet.id]
  description = "The private subnet of service environment by"
}
