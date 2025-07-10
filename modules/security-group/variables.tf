variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security group will be created"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC for SSH access"
  type        = string
}