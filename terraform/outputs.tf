output "instance_id" {
  description = "EC2 instance id"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public ip address of ec2 instance"
  value       = aws_instance.app_server.public_ip
}

output "instance_public_dns" {
  description = "Public dns of ec2 instance"
  value       = aws_instance.app_server.public_dns
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.app_sg.id
}

output "application_url" {
  description = "URL to access the application"
  value       = "http://${aws_instance.app_server.public_ip}:${var.app_port}"
}


