output "db_endpoint" {
  value       = aws_rds_cluster.service_db_cluster.endpoint
  description = "The endpoint of Aurora cluster"
}

output "db_sg" {
  value       = aws_security_group.service_db.id
  description = "The security group of MySQL RDS"
}
