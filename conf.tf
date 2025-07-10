terraform {

  required_version = ">= 1.2.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"  # Updated to latest stable version
      version = "~> 6.2.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
  
  # Apply common tags to all resources
  default_tags {
    tags = {
      Project   = "tf-deploy"
      ManagedBy = "Terraform"
    }
  }
}

# Data source for latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}