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
  vpc_security_group_ids      = [aws_security_group.sg1_prod.id]
  subnet_id                   = aws_subnet.public-subnet[count.index % length(aws_subnet.public-subnet)].id
  associate_public_ip_address = true

  user_data                   = local.prod_user_data
  user_data_replace_on_change = true

  tags = {
    Name        = "tf-deploy-web-${local.prod_config.environment}-${count.index + 1}"
    Environment = local.prod_config.environment
  }
}

resource "aws_security_group" "sg1_prod" {
    name = "sg1prod"
    vpc_id = aws_vpc.public-vpc.id
    ingress {
        from_port = 8080
        to_port   = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
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