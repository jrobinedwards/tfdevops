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
