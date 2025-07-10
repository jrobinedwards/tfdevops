# Local values to reduce repetition
locals {
  dev_config = {
    environment   = "dev"
    instance_type = "t2.micro"
    instance_count = 3
  }

# Common user data script
  user_data = <<-EOF
    #!/bin/bash
    echo "<h1>Hello World from $(hostname -f)</h1>"
    echo "<p>Environment: ${local.dev_config.environment}</p>" 
}

# Create instances using count to reduce duplication
resource "aws_instance" "web_dev" {
  count                       = local.dev_config.instance_count
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = local.dev_config.instance_type
  vpc_security_group_ids      = [module.prod_security_group.security_group_id]
  subnet_id                   = aws_subnet.public-subnet[count.index % length(aws_subnet.public-subnet)].id
  associate_public_ip_address = true

  user_data                   = local.user_data
  user_data_replace_on_change = true

  tags = {
    Name        = "tf-deploy-web-${local.dev_config.environment}-${count.index + 1}"
    Environment = local.dev_config.environment
  }
}

# reference and use security groups
module "dev_security_group" {
  source = "./modules/security-group"
  
  environment     = local.dev_config.environment
  vpc_id          = aws_vpc.public-vpc.id
  vpc_cidr_block  = aws_vpc.public-vpc.cidr_block
}

# Outputs for dev environment
output "dev_instance_ids" {
  description = "IDs of dev instances"
  value       = aws_instance.web_dev[*].id
}

output "dev_instance_public_ips" {
  description = "Public IP addresses of dev instances"
  value       = aws_instance.web_dev[*].public_ip
}