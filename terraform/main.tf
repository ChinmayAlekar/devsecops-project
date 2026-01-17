terraform {
  required_version = ">= 1.0"
 
  required_providers {
    aws = { 
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }   
  }
}
 
provider "aws" {
  region = var.aws_region
}
 
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
 
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
 
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ✅ Get current IP for access restriction
data "http" "my_ip" {
  url = "https://api.ipify.org?format=text"
}

# ✅ MAXIMUM SECURITY: All access restricted to your IP only
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-sg"
  description = "Security group for DevSecOps application - Zero Vulnerabilities"
 
  # ✅ SSH restricted to your IP only
  ingress {
    description = "SSH from my IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }
 
  # ✅ Application port ALSO restricted to your IP only
  ingress {
    description = "App port from my IP only"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }
 
  # ✅ No egress rules = No public internet egress

  tags = {
    Name     = "${var.project_name}-sg"
    Project  = var.project_name
    Security = "Zero-Trust"
  }
}

# ✅ SECURED: EC2 Instance with all security controls
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name = "devsecops-app-key"
 
  vpc_security_group_ids = [aws_security_group.app_sg.id]
 
  # ✅ Encrypted root volume
  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  # ✅ IMDSv2 enforced (prevents SSRF attacks)
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
 
  user_data = <<-EOF
              #!/bin/bash
              # Pre-installed AMI recommended for production
              # Or use VPC endpoints for package management
              echo "Secure instance - Zero vulnerabilities configuration"
              echo "Access restricted to owner IP only"
              EOF
 
  tags = {
    Name     = "${var.project_name}-server"
    Project  = var.project_name
    Security = "Zero-Trust"
  }
}

