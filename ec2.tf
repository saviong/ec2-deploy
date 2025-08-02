# Terraform configuration for AWS EC2 instance
/* This specifies the AWS provider and the region where resources will be created. */
provider "aws" {
  region = "us-east-1"

}

# Define Input Variables (like CloudFormation Parameters)
variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"

  validation {
    condition     = contains(["t2.micro", "t2.small"], var.instance_type)
    error_message = "Must be either t2.micro or t2.small for instance type."
  }
}

variable "key_name" {
  description = "Name of an existing EC2 KeyPair to enable SSH access to the instance."
  type        = string
  # No default value, so Terraform will prompt the user for it.
}

variable "my_ip" {
  description = "Your IP address to allow SSH access."
  type        = string
  default     = "0.0.0.0/0" # WARNING: Change this for security.
}

variable "ami_ssm_path" {
  description = "The SSM Parameter path for the AMI."
  type        = string
  default     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Fetch Data (Finding the latest AMI ID to dynamically get the latest Amazon Linux 2 AMI ID)
data "aws_ssm_parameter" "latest_ami" {
  name = var.ami_ssm_path
}

resource "aws_security_group" "my_sg" {
  name        = "my-instance-sg"
  description = "Enable SSH access via port 22"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  tags = {
    Name = "my-instance-sg"
  }
}

resource "aws_instance" "my_ec2" {
  ami                    = data.aws_ssm_parameter.latest_ami.value
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "myec2"
  }
}

output "instance_id" {
  description = "The Instance ID of the newly created EC2 instance."
  value       = aws_instance.my_ec2.id
}

# IP address you use to connect to your instance from the internet via SSH.
output "public_ip" {
  description = "The Public IP address of the newly created EC2 instance."
  value       = aws_instance.my_ec2.public_ip
}

# DNS hostname that AWS provides, which resolves to your public IP address
output "public_dns" {
  description = "The Public DNS name of the newly created EC2 instance."
  value       = aws_instance.my_ec2.public_dns
}
