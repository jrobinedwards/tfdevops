# Local values to reduce repetition
locals {
  prod_config = {
    environment   = "prod"
    instance_type = "t3.large"
    instance_count = 3
  }
  
  # Common user data script for prod
  prod_user_data = <<-EOF
    #!/bin/bash
    echo "<h1>Hello World from $(hostname -f)</h1>"
    echo "<p>Environment: ${local.prod_config.environment}</p>"
    EOF
}

# Create instances using count to reduce duplication
resource "aws_instance" "web_prod" {
  count                       = local.prod_config.instance_count
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = local.prod_config.instance_type
  vpc_security_group_ids      = [module.prod_security_group.security_group_id]
  subnet_id                   = aws_subnet.public-subnet[count.index % length(aws_subnet.public-subnet)].id
  associate_public_ip_address = true

  user_data                   = local.prod_user_data
  user_data_replace_on_change = true

  tags = {
    Name        = "tf-deploy-web-${local.prod_config.environment}-${count.index + 1}"
    Environment = local.prod_config.environment
  }
}

#add security groups
module "dev_security_group" {
  source = "./modules/security-group"
  
  environment     = local.prod_config.environment
  vpc_id          = aws_vpc.public-vpc.id
  vpc_cidr_block  = aws_vpc.public-vpc.cidr_block
}

# Outputs for prod environment
output "prod_instance_ids" {
  description = "IDs of prod instances"
  value       = aws_instance.web_prod[*].id
}

output "prod_instance_public_ips" {
  description = "Public IP addresses of prod instances"
  value       = aws_instance.web_prod[*].public_ip
}