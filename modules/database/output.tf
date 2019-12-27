output "db_endpoint" {
  value       = aws_db_instance.service_db.endpoint
  description = "The endpoint of MySQL RDS"
}

output "db_sg" {
  value       = aws_security_group.service_db.id
  description = "The security group of MySQL RDS"
}
