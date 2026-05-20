variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "starttech"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "availability_zones" {
  description = "Availability zones in eu-west-2"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI ID for eu-west-2"
  type        = string
  default     = "ami-0adb4b73a38358d7c"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "asg_desired" {
  description = "Desired number of EC2 instances"
  type        = number
  default     = 2
}

variable "asg_min" {
  description = "Minimum number of EC2 instances"
  type        = number
  default     = 1
}

variable "asg_max" {
  description = "Maximum number of EC2 instances"
  type        = number
  default     = 4
}
