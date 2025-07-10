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
  vpc_security_group_ids      = [aws_security_group.sg1_dev.id]
  subnet_id                   = aws_subnet.public-subnet[count.index % length(aws_subnet.public-subnet)].id
  associate_public_ip_address = true

  user_data                   = local.user_data
  user_data_replace_on_change = true

  tags = {
    Name        = "tf-deploy-web-${local.dev_config.environment}-${count.index + 1}"
    Environment = local.dev_config.environment
  }
}

# Improved security group with proper naming and rules
resource "aws_security_group" "sg1_dev" {
  name        = "tf-deploy-sg-${local.dev_config.environment}"
  description = "Security group for ${local.dev_config.environment} web servers"
  vpc_id      = aws_vpc.public-vpc.id

  # HTTP access
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access (restricted to VPC)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.public-vpc.cidr_block]
  }

  # All outbound traffic
  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "tf-deploy-sg-${local.dev_config.environment}"
    Environment = local.dev_config.environment
  }
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