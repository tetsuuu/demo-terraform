output "name" {
  value       = aws_instance.bastion.public_ip
  description = "EC2 instance public IP"
}
