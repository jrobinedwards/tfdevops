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
