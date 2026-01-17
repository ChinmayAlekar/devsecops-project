variable "aws_region" {
  description = "aws region for resources"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = "3000"
}

variable "project_name" {
  description = "Name of project"
  type        = string
  default     = "devsecops-assignment"
}
