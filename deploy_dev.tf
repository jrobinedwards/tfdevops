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

resource "aws_security_group" "sg1_dev" {
    name = "sg1dev"
    vpc_id = aws_vpc.public-vpc.id
    ingress {
        from_port = 8080
        to_port   = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
